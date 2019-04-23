//
//  Embassy+CoreDataProperties.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//
//

import Foundation
import CoreData


extension Embassy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Embassy> {
        return NSFetchRequest<Embassy>(entityName: "Embassy")
    }

    @NSManaged public var accessibility: NSNumber?
    @NSManaged public var address: String?
    @NSManaged public var dateString: String?
    @NSManaged public var isSearched: NSNumber?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var lng: NSNumber?
    @NSManaged public var locality: String?
    @NSManaged public var metro: String?
    @NSManaged public var name: String?

}
