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
        
//        if WCSession.default().isReachable == true {
//            print("Session is reachable on watch")
//            
//            let requestValues = ["command" : "start"]
//            let session = WCSession.default()
//            
//            session.sendMessage(requestValues, replyHandler: { reply in
//                print("received reply with data of " + (reply["data"] as? String)!)
//            }, errorHandler: { error in
//                print("error: \(error)")
//            })
//        }

        
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Entering session didReceiveMessage...")

    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Entering session didReceiveApplicationContext...")
    }

}
