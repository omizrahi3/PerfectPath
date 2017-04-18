//
//  Waypoint+CoreDataProperties.swift
//  
//
//  Created by Rachel Martin on 4/17/17.
//
//

import Foundation
import CoreData


extension Waypoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Waypoint> {
        return NSFetchRequest<Waypoint>(entityName: "Waypoint")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var index: Int16
    @NSManaged public var addressDictionary: NSDictionary?

}
