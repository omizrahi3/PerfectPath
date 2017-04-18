//
//  Path.swift
//  PerfectPath
//
//  Created by Rachel Martin on 3/28/17.
//  Copyright © 2017 PerfectPath. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import ObjectMapper
import CoreData

class Path: Mappable {
    var startingLocation : CLPlacemark?
    var guardianPathEnabled : Bool = false
    var routes = [MKRoute]()
    var prefferedDistanceMeters = 0.0
    var actualDistance : Double?
    var secondsTraveled : Int?
    var metersTraveled : Double?
    var mapItemWaypoints = [MKMapItem]()
    var pace : Double?
    
    /*init (startingLocation: CLPlacemark, distanceInMiles: Double, guardianPathEnabled: Bool) {
        self.startingLocation = startingLocation
        self.prefferedDistanceMeters = distanceInMiles * 1609.34
        self.guardianPathEnabled = guardianPathEnabled
    }*/
    
    init() {
    }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        mapItemWaypoints <- map["mapItemWaypoint.0.0"]
        guardianPathEnabled <- map["guardianPathEnabled"]
    }
}
