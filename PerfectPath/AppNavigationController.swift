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
        
        v.depthPreset = .depth1
        v.dividerColor = Color.blueGrey.lighten3
        v.backgroundColor = Color.blueGrey.lighten3
    }
}
