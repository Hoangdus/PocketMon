//
//  TypeEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 17/06/2025.
//
//

import Foundation
import CoreData


extension TypeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeEntity> {
        return NSFetchRequest<TypeEntity>(entityName: "TypeEntity")
    }

    @NSManaged public var slot: Int32
    @NSManaged public var type: TypeInfoEntity?

}

extension TypeEntity : Identifiable {

}
