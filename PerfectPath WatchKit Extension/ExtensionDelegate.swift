//
//  ExtensionDelegate.swift
//  PerfectPath WatchKit Extension
//
//  Created by Kasey Clark on 2/16/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if (WCSession.isSupported()) {
            print("WCSession is supported on watch")
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Entering session activationDidCompleteWith...")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Entering session didReceiveMessage with no reply handler...")
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Entering session didReceiveApplicationContext...")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Entering didReceiveMessage with a reply handler...")
        
        var replyValues = Dictionary<String, AnyObject>()
        
        //        let viewController = self.window!.rootViewController!
        //            as UIViewController
        
        print("in session with message in app delegate")
        switch message["command"] as! String {
        case "startPathNow" :
            let path = message["data"]
            print("ios -> watch, watch got startPathNow, replying now...")
            replyValues["data"] = "OK" as AnyObject?
            let rootInterfaceController = WKExtension.shared().rootInterfaceController
            rootInterfaceController?.pushController(withName: "MapController", context: path)
        //["command" : "startFavPath","data" : self.pathToSendToWatch as Any]
        case "startFavPath" :
            let path = message["data"]
            print("ios -> watch, watch got startFavPath, replying now...")
            replyValues["data"] = "OK" as AnyObject?
            let rootInterfaceController = WKExtension.shared().rootInterfaceController
            rootInterfaceController?.pushController(withName: "MapController", context: path)
//        case "emergencyContacts" :
//            print("In extension delegate with emegency contact info...")
//            let nameArray: [String] = message["nameArray"] as! [String]
//            let numberArray: [String] = message["numberArray"] as! [String]
//            print("Received emergency contacts from phone")
//            replyValues["data"] = "OK" as AnyObject?
//            let rootInterfaceController = WKExtension.shared().rootInterfaceController
//            rootInterfaceController?.pushController(withName: "EmergencyContactsController", context: [nameArray, numberArray]) as AnyObject
        default:
            break
        }
        replyHandler(replyValues)
    }
    

}
