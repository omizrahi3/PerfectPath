//
//  DashboardViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 2/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase
import Material

class DashboardViewController: UIViewController {
    @IBOutlet weak var welcome: UILabel!
    
    fileprivate var logoutButton: IconButton!
    
    var currentUserRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    var contactRef: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebaseObservers()
        prepareLogoutButton()
        prepareNavigationItem()
    }
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        self.currentUserRef = firebaseRef.child("users").child(currentUsersUid)
        self.profileRef = firebaseRef.child("profiles").child(currentUsersUid)
        self.contactRef = firebaseRef.child("contacts").child(currentUsersUid)
        
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            self.welcome.text = dictionary!["firstname"] as? String ?? "wrong"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLogout2(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        self.appDelegate.showLoginViewController()
    }

}

extension DashboardViewController {
    fileprivate func prepareLogoutButton() {
        logoutButton = IconButton(image: Icon.cm.close)
        logoutButton.addTarget(appDelegate,
                               action: #selector(AppDelegate.handleLogout),
                               for: .touchUpInside)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Dashboard"
        navigationItem.rightViews = [logoutButton]
    }
}
