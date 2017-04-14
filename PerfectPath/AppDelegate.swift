//
//  AppDelegate.swift
//  PerfectPath
//
//  Created by Kasey Clark on 2/16/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var contacts = [Contact]()
    var contactsRef: FIRDatabaseReference!
    var nameArray = [String]()
    var numberArray = [String]()
    var contactsTableViewController: ContactsTableViewController?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("In app delegate, application func")
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
        
        
        if (WCSession.isSupported()) {
            print("WCSession is supported from iOS view")
            let session = WCSession.default()
            session.delegate = self
            session.activate()
            
            if session.isPaired != true {
                print("Apple Watch is not paired")
            }
            
            if session.isWatchAppInstalled != true {
                print("WatchKit app is not installed")
            }
        } else {
            print("WatchConnectivity is not supported on this device")
        }
        
        
        return true
    }
    
    
    
    
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Entering activationDidCompleteWith...")
    }
    

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Entering didReceiveMessage for a non-nil reply handler...")
        
        var replyValues = Dictionary<String, AnyObject>()
        
        print("in session with message in app delegate")
        switch message["command"] as! String {
        case "start" :
            print("In app delegate session in case start")
            //            viewController.startPlay()
            replyValues["data"] = "KK1" as AnyObject?
        case "startPathNow" :
            print("received command: startPathNow")
            print("with data: " + String(describing: message["data"]))
        case "emergencyContacts" :
            // request from watch looks like ["command" : "emergencyContacts"]
            // reply from ios looks like ["command" : "emergencyContacts","nameArray" : nameArray as Any, "numberArray": numberArray as Any]
            print("emergencyContacts case")
            //contactsTableViewController?.viewDidLoad()
            print("first name and num is : " + (nameArray[0]) + " and " + (numberArray[0]))
            replyValues["command"] = "emergencyContacts" as AnyObject?
            replyValues["nameArray"] = nameArray as AnyObject?
            replyValues["numberArray"] = numberArray as AnyObject?
        default:
            break
        }
        replyHandler(replyValues)
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Entering didReceiveMessage for a nil reply handler...")
        
        var replyValues = Dictionary<String, AnyObject>()
        print("in session with message in app delegate")
        switch message["command"] as! String {
        case "startPathNow" :
            print("received command: startPathNow")
            print("with data: " + String(describing: message["data"]))
        default:
            break
        }
    }
    
    private func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("Entering didReceiveMessage...")
        
        var replyValues = Dictionary<String, AnyObject>()
        
        //        let viewController = self.window!.rootViewController!
        //            as UIViewController
        print("in session with message in app delegate")
        switch message["command"] as! String {
        case "startPathNow" :
            print("received command: startPathNow")
            print("with data: " + String(describing: message["data"]))
        case "emergencyContacts" :
            // request from watch looks like ["command" : "emergencyContacts"]
            // reply from ios looks like ["command" : "emergencyContacts","nameArray" : nameArray as Any, "numberArray": numberArray as Any]
            print("emergencyContacts case")
            replyValues["command"] = "emergencyContacts" as AnyObject?
            replyValues["nameArray"] = ["molly", "sadie"] as AnyObject?
            replyValues["numberArray"] = ["1234567899","1234567899"] as AnyObject?
        default:
            break
        }
        replyHandler(replyValues)
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
        
        let DVC = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        
        window!.rootViewController = AppNavigationController(rootViewController: DVC)
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
}

extension UIViewController {
    var appDelegate : AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
}


//// ******************** session for watch connectivity below *********************
//extension AppDelegate: WCSessionDelegate {
//    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
//    @available(iOS 9.3, *)
//    public func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
//    
//    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
//    @available(iOS 9.3, *)
//    public func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    
//    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
//    @available(iOS 9.3, *)
//    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        print("Entering session...")
//        
//        
//        
//        
//        
//        
//        
//        //                if let reference = message["reference"] as? String, let boardingPass = QRCode(reference) {
//        //                    replyHandler(["boardingPassData": boardingPass.PNGData])
//        //                }
//
//    
//    }
//    
//    
//    
//    
//}
//
//
//
//
