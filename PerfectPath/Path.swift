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

class Path: NSObject {
    var waypointLocations = [MKMapItem]()
    var distance = 0.0
    
    init (waypointLocations: [MKMapItem], distance: Double) {
        self.waypointLocations = waypointLocations
        self.distance = distance
    }
    
}
