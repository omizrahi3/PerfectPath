//
//  Contact.swift
//  PerfectPath
//
//  Created by Odell Mizrahi on 3/15/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class Crime: NSObject {
    var key: String?
    var crimetype: String!
    var location: String!
    var x_coord: NSNumber!
    var y_coord: NSNumber!
    
    let ctKey = "crime_type"
    let lnKey = "location"
    var xKey = "x"
    var yKey = "y"
    
    init (fullname: String!, phonenumber: String!, x_coordinate: NSNumber!, y_coordinate: NSNumber!) {
        self.crimetype = fullname
        self.location = phonenumber
        self.x_coord = x_coordinate
        self.y_coord = y_coordinate
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let dictionary = snapshot.value as? NSDictionary
        
        self.crimetype = dictionary![ctKey] as? String ?? ""
        self.location = dictionary![lnKey] as? String ?? ""
        self.x_coord = dictionary![xKey] as? NSNumber
        self.y_coord = dictionary![yKey] as? NSNumber
        //print(self.y_coord)
    }
    
    func getSnapshotValue() -> NSDictionary {
        let valueDict = [ctKey: crimetype, lnKey: location, xKey: x_coord, yKey: y_coord] as? NSDictionary
        return valueDict!
    }
}
