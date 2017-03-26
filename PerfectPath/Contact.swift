//
//  Contact.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/15/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class Contact: NSObject {
    var key: String?
    var fullname: String!
    var phonenumber: String!
    
    let fnKey = "fullname"
    let pnKey = "phonenumber"
    
    init (fullname: String!, phonenumber: String!) {
        self.fullname = fullname
        self.phonenumber = phonenumber
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let dictionary = snapshot.value as? NSDictionary
        //self.welcome.text = dictionary!["firstname"] as? String ?? "wrong"

        self.fullname = dictionary![fnKey] as? String ?? ""
        self.phonenumber = dictionary![pnKey] as? String ?? ""
    }
    
    func getSnapshotValue() -> NSDictionary {
        let valueDict = [fnKey: fullname, pnKey: phonenumber] as? NSDictionary
        return valueDict!
    }
}
