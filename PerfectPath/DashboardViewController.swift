//
//  DashboardViewController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 2/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {
    @IBOutlet weak var welcome: UILabel!
    
    var currentUserRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    var contactRef: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFirebaseObservers()
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
