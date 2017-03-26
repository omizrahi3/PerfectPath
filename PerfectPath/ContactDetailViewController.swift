//
//  ContactDetailViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/25/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    //@IBOutlet weak var quoteLabel: UILabel!
    //@IBOutlet weak var movieLabel: UILabel!
    var latestRecievedContact: Contact?
    var contactRef = FIRDatabaseReference()
    
    var fullnameTextField: UITextField!
    var phonenumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit,
                                                            target: self,
                                                            action: #selector(ContactDetailViewController.showEditQuoteDialog))
        prepareNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateView()
        contactRef.observe(.value, with: { (snapshot) in
            self.latestRecievedContact = Contact(snapshot: snapshot)
        self.updateView()
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contactRef.removeAllObservers()
    }
    
    func showEditQuoteDialog() {
        let alertController = UIAlertController(title: "Edit",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.text = self.latestRecievedContact?.fullname
            textField.placeholder = "Name"
            self.fullnameTextField = textField
            textField.addTarget(self, action: #selector(ContactDetailViewController.contactChange), for: UIControlEvents.editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.text = self.latestRecievedContact?.phonenumber
            textField.placeholder = "Phone Number"
            self.phonenumberTextField = textField
            textField.addTarget(self, action: #selector(ContactDetailViewController.contactChange), for: UIControlEvents.editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        let createQuoteAction = UIAlertAction(title: "Done Editing", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createQuoteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func contactChange() {
        let editedContact = Contact(fullname: fullnameTextField.text!, phonenumber: phonenumberTextField.text!)
        contactRef.setValue(editedContact.getSnapshotValue())
    }
    
    func updateView() {
        quoteLabel.text = latestRecievedContact?.fullname
        movieLabel.text = latestRecievedContact?.phonenumber
    }
}

extension ContactDetailViewController {
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Edit Contacts"
    }
}
