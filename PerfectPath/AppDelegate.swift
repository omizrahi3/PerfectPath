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
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var nameArray = [String]()
    var numberArray = [String]()
    var contactsTableViewController: ContactsTableViewController?
    var favPathNames = [String]()
    var favPathArray = [WatchPath]()
    
    var contacts = [Contact]()
    var contactsRef: FIRDatabaseReference!
    var profileRef: FIRDatabaseReference!
    
    var latestRecievedProfile: Profile?
    


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
        
        setupFirebaseObservers()
        //TODO Add child to listen child added
//        contactsRef.observe(.childAdded, with: { (snapshot) in
//            print("childAdded")
//            let addedContact = Contact(snapshot: snapshot)
//            print(addedContact.getSnapshotValue())
//            self.contacts.insert(addedContact, at: 0)
//        })
        
        profileRef.observe(.value, with: { (snapshot) in
            self.latestRecievedProfile = Profile(snapshot: snapshot)
        })
        
        
        return true
    }
    
    
    func setupFirebaseObservers() {
        let firebaseRef = FIRDatabase.database().reference()
        let currentUsersUid = FIRAuth.auth()!.currentUser!.uid
        contactsRef = firebaseRef.child("contacts").child(currentUsersUid)
        profileRef = firebaseRef.child("profiles").child(currentUsersUid)
    }
    
    func sendMessagesToEmergencyContacts() {
        print("TODO : In sendMessagesToEmergencyContacts...")
        for (index, name) in self.nameArray.enumerated() {
            print ("sending message to " + String(name))
            print (self.numberArray[index])
            
            let str1 = "EMERGENCY MESSAGE FROM PERFECT PATH. Please contact your friend "
            let str2 = (self.latestRecievedProfile?.firstname)! + " " + (self.latestRecievedProfile?.lastname)!
            let str3 = " as they did not respond from their Guardian Check in."
            let message = "\(str1) \(str2) \(str3)"
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters: Parameters = [
                "To": self.numberArray[index],
                "Body": message
            ]
            Alamofire.request("https://warm-inlet-35920.herokuapp.com/sms", method: .post, parameters: parameters, headers: headers).response { response in
                print(response)
                
            }
        }
    }
    
    
    
    // TODO : this is called when you cancel the alert after the timer has expired and original message has been sent to emergency contacts -- this message lets ECs know that you are in fact safe.
    func sendImOKMsgToEmergencyContacts() {
        print("TODO : In sendImOKMsgToEmergencyContacts... Alert cancelled after location message sent to Emergency Contacts.")
        
        for (index, name) in self.nameArray.enumerated() {
            print ("sending message to " + String(name))
            print (self.numberArray[index])
            
            let str1 = "ALL-OK MESSAGE FROM PERFECT PATH. Your friend "
            let str2 = (self.latestRecievedProfile?.firstname)! + " " + (self.latestRecievedProfile?.lastname)!
            let str3 = " has now marked themselves as OK with Guardian Check in."
            let message = "\(str1) \(str2) \(str3)"
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters: Parameters = [
                "To": self.numberArray[index],
                "Body": message
            ]
            Alamofire.request("https://warm-inlet-35920.herokuapp.com/sms", method: .post, parameters: parameters, headers: headers).response { response in
                print(response)
                
            }
        }

        
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
        case "favPathsList" :
            // request from watch looks like ["command" : "favPathsList"]
            // reply from ios looks like ["command" : "favPathsList","favPaths" : favPathArray as Any, "favPathNames" : favPathNames]
            print("favPathList case")
            replyValues["command"] = "favPathList" as AnyObject?
            self.favPathNames = ["Morning Walk", "Tech Square"]
            replyValues["favPathNames"] = self.favPathNames as AnyObject?
            replyValues["favPaths"] = self.favPathArray as AnyObject?
        case "alertContacts" :
            print("alertContacts case")
            replyValues["command"] = "alertContacts" as AnyObject?
            replyValues["status"] = "OK" as AnyObject?
            self.sendMessagesToEmergencyContacts()
        case "okContacts" :
            print("okContacts case")
            replyValues["command"] = "okContacts" as AnyObject?
            replyValues["status"] = "OK" as AnyObject?
            self.sendImOKMsgToEmergencyContacts()
            
            
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
