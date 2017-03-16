//
//  Contacts.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/15/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class Contacts: NSObject {
    var key: String
    var lastname: String
    var phonenumber: String
    
    let fnKey = "firstname"
    let lnKey = "lastname"
    let pnKey = "phonenumber"
    
    init (firstname: String, lastname: String, phonenumber: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.firstname = (value![fnKey] as! NSString) as String
        self.lastname = (value![lnKey] as! NSString) as String
        self.phonenumber = (value![pnKey] as! NSString) as String
    }
    
    func getSnapshotValue() -> NSDictionary {
        return [fnKey: firstname, lnKey: lastname, pnKey: phonenumber]
    }
}
