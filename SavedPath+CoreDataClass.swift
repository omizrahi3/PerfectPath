//
//  SavedPath+CoreDataClass.swift
//  
//
//  Created by Rachel Martin on 4/17/17.
//
//

import Foundation
import CoreData

@objc(SavedPath)
public class SavedPath: NSManagedObject {

    @NSManaged public var startingLocation: CLPlacemark?
    @NSManaged public var waypoints
    @NSManaged public var distanceInMiles : Double
}
