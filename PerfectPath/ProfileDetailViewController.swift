//
//  ProfileDetailViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/26/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class ProfileDetailViewController: UIViewController {
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    
    var latestRecievedProfile: Profile?
    
    //@IBOutlet weak var quoteLabel: UILabel!
    //@IBOutlet weak var movieLabel: UILabel!
    var profileRef: FIRDatabaseReference!
    
    var firstnameTextField: UITextField!
    var lastnameTextField: UITextField!
    var phonenumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit,
                                                            target: self,
                                                            action: #selector(ProfileDetailViewController.showEditQuoteDialog))
        setupFirebaseObservers()
        prepareNavigationItem()
    }
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        self.profileRef = firebaseRef.child("profiles").child(currentUsersUid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileRef.observe(.value, with: { (snapshot) in
            self.latestRecievedProfile = Profile(snapshot: snapshot)
            self.updateView()
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        profileRef.removeAllObservers()
    }
    
    func showEditQuoteDialog() {
        let alertController = UIAlertController(title: "Edit",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.text = self.latestRecievedProfile?.firstname
            textField.placeholder = "First Name"
            self.firstnameTextField = textField
            textField.addTarget(self, action: #selector(ProfileDetailViewController.profileChange), for: UIControlEvents.editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.text = self.latestRecievedProfile?.lastname
            textField.placeholder = "Last Name"
            self.lastnameTextField = textField
            textField.addTarget(self, action: #selector(ProfileDetailViewController.profileChange), for: UIControlEvents.editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.text = self.latestRecievedProfile?.phonenumber
            textField.placeholder = "Phone Number"
            self.phonenumberTextField = textField
            textField.addTarget(self, action: #selector(ProfileDetailViewController.profileChange), for: UIControlEvents.editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        let createQuoteAction = UIAlertAction(title: "Done Editing", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createQuoteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func profileChange() {
        let editProfile = Profile(firstname: firstnameTextField.text!,lastname: lastnameTextField.text!, phonenumber: phonenumberTextField.text!)
        profileRef.setValue(editProfile.getSnapshotValue())
    }
    
    func updateView() {
        firstnameLabel.text = latestRecievedProfile?.firstname
        lastnameLabel.text = latestRecievedProfile?.lastname
        phonenumberLabel.text = latestRecievedProfile?.phonenumber
    }
}

extension ProfileDetailViewController {
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Edit Profile"
    }
}
