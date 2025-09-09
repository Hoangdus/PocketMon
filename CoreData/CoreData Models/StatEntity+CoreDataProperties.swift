//
//  StatEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 17/06/2025.
//
//

import Foundation
import CoreData


extension StatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatEntity> {
        return NSFetchRequest<StatEntity>(entityName: "StatEntity")
    }

    @NSManaged public var base_stat: Int32
    @NSManaged public var stat: StatInfoEntity?

}

extension StatEntity : Identifiable {

}
