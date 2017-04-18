//
//  SPWaypoint+CoreDataProperties.swift
//  
//
//  Created by Rachel Martin on 4/18/17.
//
//

import Foundation
import CoreData


extension SPWaypoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SPWaypoint> {
        return NSFetchRequest<SPWaypoint>(entityName: "SPWaypoint")
    }

    @NSManaged public var addressDictionary: NSObject?
    @NSManaged public var index: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
