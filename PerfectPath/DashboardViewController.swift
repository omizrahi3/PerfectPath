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
    
    fileprivate var logoutButton: IconButton!
    
    var currentUserRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    var contactRef: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLogoutButton()
        prepareNavigationItem()
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
