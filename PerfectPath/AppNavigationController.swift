//
//  AppNavigationController.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/24/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten3
    }
}
