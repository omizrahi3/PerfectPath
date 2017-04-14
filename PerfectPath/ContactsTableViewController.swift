//
//  ContactsTableViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/25/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase
import Material
import WatchConnectivity

class ContactsTableViewController: UITableViewController {
    
    let contactCellIdentifier = "ContactCell"
    let noContactsCellIdentifier = "NoContactCell"
    let showDetailSegueIdentifier = "ShowDetailSegue"
    
    fileprivate var editButton: UIBarButtonItem!
    fileprivate var addButton: UIBarButtonItem!
    
    var contacts = [Contact]()
    var contactsRef: FIRDatabaseReference!
    var nameArray = [String]()
    var numberArray = [String]()
    let appDelegateRef = UIApplication.shared.delegate as! AppDelegate


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupFirebaseObservers()
        prepareAddEditButtons()
        prepareNavigationItem()
        

    }
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        contactsRef = firebaseRef.child("contacts").child(currentUsersUid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts.removeAll()
        tableView.reloadData()
        
        //TODO Add child to listen child added
        contactsRef.observe(.childAdded, with: { (snapshot) in
            print("childAdded")
            let addedContact = Contact(snapshot: snapshot)
            self.contacts.insert(addedContact, at: 0)            
            self.appDelegateRef.nameArray.insert(addedContact.fullname, at: 0)
            self.appDelegateRef.numberArray.insert(addedContact.phonenumber, at: 0)
            
            if (self.contacts.count == 1) {
                self.tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            
        })
        //TODO Add child to listen child edited
        contactsRef.observe(.childChanged, with: { (snapshot) in
            print("childChanged")
            let modifiedContact = Contact(snapshot: snapshot)
            for c in self.contacts {
                if c.key == modifiedContact.key {
                    let contactIndex = self.contacts.index(of: c) // for watch
                    c.key = modifiedContact.key
                    c.fullname = modifiedContact.fullname
                    c.phonenumber = modifiedContact.phonenumber
                    self.appDelegateRef.nameArray.remove(at: contactIndex!)
                    self.appDelegateRef.numberArray.remove(at: contactIndex!)
                    self.appDelegateRef.nameArray.insert(c.fullname, at: contactIndex!)
                    self.appDelegateRef.numberArray.insert(c.phonenumber, at: contactIndex!)
                    break
                }
            }
            self.tableView.reloadData()
        })
        //TODO Add child to listen child deleted
        contactsRef.observe(.childRemoved, with: { (snapshot) in
            print("childRemoved")
            let deletedContact = Contact(snapshot: snapshot)
            for c in self.contacts {
                if c.key == deletedContact.key {
                    let contactIndex = self.contacts.index(of: c)
                    self.contacts.remove(at: contactIndex!)
                    self.appDelegateRef.nameArray.remove(at: contactIndex!)
                    self.appDelegateRef.numberArray.remove(at: contactIndex!)
                    break
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contactsRef.removeAllObservers()
    }
    
    public func getNameArrayForWatch() -> [String] {
        print("In getNameArrayForWatch...")
        if self.nameArray == nil {
            print("nameArray is nil")
        }
        return self.nameArray
    }
    public func getNumberArrayForWatch() -> [String] {
        print("In getNumberArrayForWatch...")
        return self.numberArray
    }
    
    func showAddContactDialog() {
        let alertController = UIAlertController(title: "Create a new contact",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Fullname"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone Number"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        let createContactAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let fullnameTextField = alertController.textFields![0]
            let pnTextField = alertController.textFields![1]
            let contact = Contact(fullname: fullnameTextField.text!, phonenumber: pnTextField.text!)
            self.contactsRef.childByAutoId().setValue(contact.getSnapshotValue())
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createContactAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(contacts.count, 1)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        
        if contacts.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: noContactsCellIdentifier, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath)
            let contact = contacts[indexPath.row]
            cell.textLabel?.text = contact.fullname
            cell.detailTextLabel?.text = contact.phonenumber
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return contacts.count > 0
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if self.contacts.count == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            /*
            contacts.remove(at: indexPath.row)
            if contacts.count == 0 {
                tableView.reloadData()
                setEditing(false, animated: true)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            */
            tableView.reloadData()
            let key = contacts[indexPath.row].key
            contactsRef.child(key!).removeValue()
            
            
            
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegueIdentifier {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = contacts[indexPath.row]
                (segue.destination as! ContactDetailViewController).contactRef = contactsRef.child(contact.key!)
            }
        }
    }
    
}

extension ContactsTableViewController {

    fileprivate func prepareAddEditButtons() {
        editButton = self.editButtonItem
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                    target: self,
                                    action: #selector(ContactsTableViewController.showAddContactDialog))
    }

    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Contacts"
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }
}
