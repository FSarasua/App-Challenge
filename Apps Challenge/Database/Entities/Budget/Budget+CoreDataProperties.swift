//
//  Budget+CoreDataProperties.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var definition: String
    @NSManaged public var email: String
    @NSManaged public var location: String
    @NSManaged public var name: String
    @NSManaged public var phone: Int32
    @NSManaged public var subcategory: String

}

extension Budget : Identifiable {

}
