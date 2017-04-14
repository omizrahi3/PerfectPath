//
//  EmergencyContactsController.swift
//  PerfectPath
//
//  Created by Kasey Clark on 4/13/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class EmergencyContactsController: WKInterfaceController {
    
    
    
    @IBOutlet var contactsTable: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("EmergencyContactsController awoke with context...")
        
        
        if let array = context as? [Any] {
            print("Context is an array")
            var nameArray: [String] = array[0] as! [String]
            var numberArray: [String] = array[1] as! [String]
            contactsTable.setNumberOfRows(nameArray.count, withRowType: "ContactsRow")
            print("first name is: " + nameArray[0])
            print("first num is: " + numberArray[0])
            
        }
        
        
    }
    
        
        // Configure interface objects here.

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Ask phone for contact list
        getContactsFromPhone()
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getContactsFromPhone() {
        print("Entering getContactsFromPhone in EmergencyContactsController...")
        if WCSession.default().isReachable == true {
            print("Session is reachable on watch")
            // request from watch looks like ["command" : "emergencyContacts"]
            // reply from ios looks like ["command" : "emergencyContacts","fullnames" : nameArray as Any, "numbers": numberArray as Any]
            let requestValues = ["command" : "emergencyContacts"]
            let session = WCSession.default()
            session.sendMessage(requestValues, replyHandler: { (reply) -> Void in
                //print("sent message: " + String(describing: requestValues["command"]))
                var nameArray = [String]()
                nameArray = (reply["nameArray"] as AnyObject) as! [String]
                var numberArray = [String]()
                numberArray = reply["numberArray"] as AnyObject as! [String]
                print("First name and numbers is " + String(describing: nameArray[0]) + " and " + String(describing: numberArray[0]))
                self.contactsTable.setNumberOfRows(nameArray.count, withRowType: "ContactsRowControllerIdentifier")
                for (index, name) in nameArray.enumerated() {
                    let row = self.contactsTable.rowController(at: index) as! ContactsRowController
                    row.nameLabel.setText(name)
                }
                for (index, number) in numberArray.enumerated() {
                    let row = self.contactsTable.rowController(at: index) as! ContactsRowController
                    row.numberLabel.setText(number)
                }
                print("# names: " + String(nameArray.count))
                print("# #'s: " + String(numberArray.count))
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }
    
}
