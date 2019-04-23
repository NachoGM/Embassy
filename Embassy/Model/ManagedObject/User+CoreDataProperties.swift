//
//  User+CoreDataProperties.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var address: String?
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}
