//
//  MapController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MapController: WKInterfaceController {
    
    
    //var session: WCSession?
    
    //variables
    @IBOutlet var guardianBtn: WKInterfaceButton!
    var internalTimer = Timer()
    var binaryCount = 0b0000
    let testTenSecondBinary = 0b00001010
    let oneMinBinary = 0b00111100
    let fiveMinBinary = 0b100101100
    let tenMinBinary = 0b1001011000
    
    @IBOutlet var startBtn: WKInterfaceButton!
    @IBOutlet var testLabel: WKInterfaceLabel!
    
    /* SENDING MESSAGE WATCH -> PHONE */
    @IBAction func didTapStartBtn() {
        print("Entering didTapStartBtn...")
        if WCSession.default().isReachable == true {
            print("Session is reachable on watch")
            
            let requestValues = ["command" : "start"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                self.testLabel.setText(reply["data"] as? String)
                print("sent message: " + String(describing: requestValues["command"]))
                print("rec message: " + String(describing: reply["data"]))
            }, errorHandler: { error in
                print("error: \(error)")
            })
            
            
        }
    }

    // Override to grab information pushed from SetCheckInController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Entering awake...")
        
        // Make sure data was passed properly from SetCheckInController
        if let _: [Int] = context as? [Int] {
            binaryCount = testTenSecondBinary
            start() // Start the timer here
            self.guardianBtn.setBackgroundColor(UIColor.green)// change the color of the guardian button once it is enabled
        }
    }
    
    override func didAppear() {
        super.didAppear()
        print("Entering didAppear...")
        // 1
//        if WCSession.isSupported() {
//            print("WCSession is supported")
//            
//            
//            // 2
//            session = WCSession.default()
//            // 3
//            session!.sendMessage(["favPathName": "PI Path"], replyHandler: { (response) -> Void in
//                // 4
//                let favPathData = response["favPathData"]
//                if  favPathData != nil {
//                    print("favPathData is not nil")
//                    // 5
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        self.guardianBtn.setBackgroundColor(UIColor.purple)
//                    })
//                }
//                print("favPathData is nil")
//            }, errorHandler: { (error) -> Void in
//                // 6
//                print(error)
//            })
//        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func start() {
        internalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MapController.countDown), userInfo: nil, repeats: true)
    }
    
    
    
    
    
    func countDown() {
        
        binaryCount -= 0b0001
        // if the counter reached 16, reset it to 0
        if (binaryCount == 0b0000) {
            print("binaryCount: 0")
            
            //stop timer when it reaches 0
            internalTimer.invalidate()
            
            //set value of button back to light grey 85 RGB and 1.0 alpha
            self.guardianBtn.setBackgroundColor(UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0))
            
            //trigger AlertTimerCountdownController to pop up
            self.pushController(withName: "AlertTimerCountdownController", context: nil)
        }
    }
}


//extension MapController: WCSessionDelegate {
//    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
//    @available(watchOS 2.2, *)
//    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("in session in map controller extension")
//        
//    }
//    
//    
////    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
////        print("Entering session with didReceiveMessage...")
////
////        if let currPath = message["currPath"] as? Any {
////            print("Watch received currPath message")
////            replyHandler: {
////
////            
////        }
////    }
//    
////    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
////        print("Entering session with didReceiveApplicationContext...")
////        if WCSession.default()
////    }
//
//}
//
