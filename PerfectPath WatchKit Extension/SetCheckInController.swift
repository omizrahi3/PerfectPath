//
//  SetCheckInController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 3/2/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation


@available(watchOSApplicationExtension 3.0, *)
class SetCheckInController: WKInterfaceController {
    
    

    // variables
    @IBOutlet var minutesLabel: WKInterfaceLabel!
    let oneStr = "1 min"
    let fiveStr = "5 mins"
    let tenStr = "10 mins"
    var currStr = ""
    var guardianArray = [5] //guardainArray[0] is value of timer used to pass to MapController - 5 is default value
    
    
    
    
    
    // if currently 5 -> 10, if 1 -> 5
    @IBAction func swipedLeft(_ sender: Any) {
        print("Recognized swipe left")
        if (currStr.isEqual(fiveStr)) {
            print("Minutes at 5, setting to 10")
            minutesLabel.setText(tenStr)
            self.currStr = tenStr;
            self.guardianArray[0] = 10
        };
        if (currStr.isEqual(oneStr)) {
            print("Minutes at 1, setting to 5")
            minutesLabel.setText(fiveStr)
            self.currStr = fiveStr
            self.guardianArray[0] = 5
        }

    }
    
    // if currently 10 -> 5, if 5 -> 1
    @IBAction func swipedRight(_ sender: Any) {
        print("Recognized swipe right")
        if (currStr.isEqual(fiveStr)) {
            print("Minutes at 5, setting to 1")
            minutesLabel.setText(oneStr)
            self.currStr = oneStr;
            self.guardianArray[0] = 1
        };
        if (currStr.isEqual(tenStr)) {
            print("Minutes at 10, setting to 5")
            minutesLabel.setText(fiveStr)
            self.currStr = fiveStr
            self.guardianArray[0] = 5
        }
    }

    

    // Pushing timer value that user selected so that Map Controller
    // can grab value and display/use it.
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        
        // Return data to be accessed in other controller below
        print("In contextForSeque in SetCheckInController sending the following to MapController")
        print("guardianArray[0]: \(self.guardianArray[0])")
        return self.guardianArray
    }
    
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        currStr += fiveStr
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
