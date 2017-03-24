//
//  SavedPathsViewControlloer.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Material

class SavedPathsViewControlloer: UIViewController {
    fileprivate var logoutButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLogoutButton()
        prepareNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SavedPathsViewControlloer {
    fileprivate func prepareLogoutButton() {
        logoutButton = IconButton(image: Icon.cm.close)
        logoutButton.addTarget(appDelegate,
                               action: #selector(AppDelegate.handleLogout),
                               for: .touchUpInside)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Saved Paths"
        navigationItem.rightViews = [logoutButton]
    }
}
