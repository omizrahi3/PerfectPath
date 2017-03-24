//
//  AppDelegate.swift
//  PerfectPath
//
//  Created by Kasey Clark on 2/16/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()

        // To give the iOS status bar light icons & text
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Programatically initialize the first view controller.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let showLoginScreen = FIRAuth.auth()?.currentUser == nil
        
        if showLoginScreen {
            showLoginViewController();
        } else {
            showDashboardViewController();
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func handleLogin() {
        showDashboardViewController()
    }
    
    func handleLogout() {
        try! FIRAuth.auth()!.signOut()
        showLoginViewController()
    }
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)

        let LVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        window!.rootViewController = AppNavigationController(rootViewController: LVC)
    }
    
    func showDashboardViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "dashboardNav")
    }
    
}

extension UIViewController {
    var appDelegate : AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
}


