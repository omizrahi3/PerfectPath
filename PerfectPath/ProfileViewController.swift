//
//  ProfileViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/15/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var contactFnTextField: UITextField!
    @IBOutlet weak var contactLnTextField: UITextField!
    @IBOutlet weak var contactPnTextField: UITextField!
    
    var currentUserRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    var contactsRef: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebaseObservers()
    }
    @IBAction func didTapAddContact(_ sender: Any) {
        handleAddContact()
    }
    
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        self.currentUserRef = firebaseRef.child("users").child(currentUsersUid)
        self.profileRef = firebaseRef.child("profiles").child(currentUsersUid)
        self.contactsRef = firebaseRef.child("contacts").child(currentUsersUid)
        
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            self.firstnameTextField.text = dictionary!["firstname"] as? String ?? "wrong"
            self.lastnameTextField.text = dictionary!["lastname"] as? String ?? "wrong"
            self.phonenumberTextField.text = dictionary!["phonenumber"] as? String ?? "wrong"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleAddContact() {
        let newContact = Contact(firstname: contactFnTextField.text!,
                                 lastname: contactLnTextField.text!,
                                 phonenumber: contactPnTextField.text!)
        self.contactsRef.childByAutoId().setValue(newContact.getSnapshotValue())
        print(newContact)
    }

}
