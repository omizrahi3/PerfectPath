//
//  SavedPath+CoreDataProperties.swift
//  
//
//  Created by Rachel Martin on 4/17/17.
//
//

import Foundation
import CoreData


extension SavedPath {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPath> {
        return NSFetchRequest<SavedPath>(entityName: "SavedPath")
    }

    @NSManaged public var waypoints: NSObject?

}
