//
//  AlertTimerCountdownController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class AlertTimerCountdownController: WKInterfaceController {
    
    
    
    // variables
    @IBOutlet var timerLabel: WKInterfaceLabel!
    var internalTimer = Timer()
    var binaryCount = 0b0000
    
    
    @IBAction func didTapCancelAlertsBtn() {
        
        // stop internal timer
        internalTimer.invalidate()
        
        // revert back to the mapcontroller screen
        self.pushController(withName: "MapController", context: nil)
        
        // if binaryCount negative, means message already send to ECs and then you cancelled so you need to send another message saying im okay false alarm.
        if (binaryCount < 0b000000) {
            // send a message to ECs again saying you're okay
            self.askPhoneToTellContactsImOK()
        }
        
        
    }
    

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //binaryCount = 0b111100 //set this to 60 secs here
        binaryCount = 0b001010
        start()
        
        // Configure interface objects here.
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
        internalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AlertTimerCountdownController.countDown), userInfo: nil, repeats: true)
    }

    
    
    func countDown() {
        
        binaryCount -= 0b000001
        // if the counter reached 0, send the text message
        if (binaryCount == 0b000000) {
            print("Timer hit 0")
            // send message to emergency contact
            self.askPhoneToAlertContacts()
        }
        if (binaryCount >= 0b000000 ) {
            // only update the next if it is above 0
            updateText()
        }
        
    }
    
    func askPhoneToAlertContacts() {
        print("Entering askPhoneToAlertContacts in AlertTimerCountdownController...")
        if WCSession.default().isReachable == true {
            print("Session is reachable on watch")
            // request from watch looks like ["command" : "alertContacts"]
            // reply from ios looks like ["command" : "alertContacts","status" : "OK"]
            let requestValues = ["command" : "alertContacts"]
            let session = WCSession.default()
            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                let status = reply["status"] as! String
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }
    
    // TODO : this is called when you cancel the alert after the timer has expired and original message has been sent to emergency contacts -- this message lets ECs know that you are in fact safe.
    func askPhoneToTellContactsImOK() {
        print("Entering askPhoneToTellContactsImOK in AlertTimerCountdownController...")
        if WCSession.default().isReachable == true {
            print("Session is reachable on watch")
            // request from watch looks like ["command" : "okContacts"]
            // reply from ios looks like ["command" : "okContacts","status" : "OK"]
            let requestValues = ["command" : "okContacts"]
            let session = WCSession.default()
            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                let status = reply["status"] as! String
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }

        
    }
    
    
    // Update the text from the label, by always maintaining 4 digits.
    func updateText() {
        // Convert from Binary to String
        //let text = String(binaryCount, radix:2)
        let text = String(binaryCount)
        // Set label
        timerLabel.setText(text)
    }
    
    

}
