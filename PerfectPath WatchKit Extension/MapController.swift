//
//  MapController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation


class MapController: WKInterfaceController {
    
    //variables
    @IBOutlet var guardianBtn: WKInterfaceButton!
    @IBOutlet var guardianTimer: WKInterfaceTimer!
    @IBOutlet var testLabel: WKInterfaceLabel!
    var internalTimer = Timer()
    var binaryCount = 0b0000
    let testTenSecondBinary = 0b00001010
    let oneMinBinary = 0b00111100
    let fiveMinBinary = 0b100101100
    let tenMinBinary = 0b1001011000
    

    // Override to grab information pushed from SetCheckInController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Make sure data was passed properly from SetCheckInController
        if let timerVal: [Int] = context as? [Int] {
            self.testLabel.setText(String(timerVal[0]))
            
            binaryCount = testTenSecondBinary
            
            // TODO set the binary timer according to the user value
            
            
            
            // Start the timer here
            start()
            
            // change the color of the guardian button once it is enabled
            self.guardianBtn.setBackgroundColor(UIColor.green)
        }
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
            self.guardianBtn.setBackgroundColor(UIColor(red:85, green:85, blue:85, alpha:1.0))
            
            //trigger AlertTimerCountdownController to pop up
            self.pushController(withName: "AlertTimerCountdownController", context: nil)
            
            
            
        }
        
        
        //updateText()
    }
    
    
    
//    // Update the text from the label, by always maintaining 4 digits.
//    func updateText() {
//        
//        // Convert from Binary to String
//        var text = String(binaryCount, radix:2)
//        
//        // Pad "0" to the left, to always have 4 binary digits
//        for i in 0..<4 - count(text) {
//            text = "0" + text;
//        }
//        
//        testLabel.text = text
//    }

}
