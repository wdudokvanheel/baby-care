//
//  BabyAction+CoreDataProperties.swift
//  BabyCare
//
//  Created by Wesley Dudok van Heel on 14/01/2024.
//
//

import Foundation
import CoreData


extension BabyAction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BabyAction> {
        return NSFetchRequest<BabyAction>(entityName: "BabyAction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var action: String?
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?

}

extension BabyAction : Identifiable {

}
