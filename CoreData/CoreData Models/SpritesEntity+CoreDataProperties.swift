//
//  SpritesEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 17/06/2025.
//
//

import Foundation
import CoreData


extension SpritesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpritesEntity> {
        return NSFetchRequest<SpritesEntity>(entityName: "SpritesEntity")
    }

    @NSManaged public var back_default: String?
    @NSManaged public var back_shiny: String?
    @NSManaged public var front_default: String
    @NSManaged public var front_shiny: String

}

extension SpritesEntity : Identifiable {

}
