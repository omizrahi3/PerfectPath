//
//  ResetPasswordViewController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Material

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "PerfectPath"
        navigationItem.detail = "Forgot Password"
    }
}
