//
//  Profile.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/26/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase

class Profile: NSObject {
    var key: String?
    var firstname: String!
    var lastname: String!
    var phonenumber: String!
    
    let fnKey = "firstname"
    let lnKey = "lastname"
    let pnKey = "phonenumber"
    
    init (firstname: String!, lastname: String!, phonenumber: String!) {
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let dictionary = snapshot.value as? NSDictionary
        self.firstname = dictionary![fnKey] as? String ?? ""
        self.lastname = dictionary![lnKey] as? String ?? ""
        self.phonenumber = dictionary![pnKey] as? String ?? ""
    }
    
    func getSnapshotValue() -> NSDictionary {
        /*
        let valueDict = [fnKey: firstname, lnKey: lastname, pnKey: phonenumber] as? NSDictionary
        return valueDict!
 */
        let valueDict = [fnKey: firstname, lnKey: lastname, pnKey: phonenumber]
        return valueDict as NSDictionary
    }
}
