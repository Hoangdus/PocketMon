//
//  TypeInfoEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 17/06/2025.
//
//

import Foundation
import CoreData


extension TypeInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeInfoEntity> {
        return NSFetchRequest<TypeInfoEntity>(entityName: "TypeInfoEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension TypeInfoEntity : Identifiable {

}
