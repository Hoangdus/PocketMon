//
//  StatsEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 16/06/2025.
//
//

import Foundation
import CoreData


extension StatsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatsEntity> {
        return NSFetchRequest<StatsEntity>(entityName: "StatsEntity")
    }

    @NSManaged public var base_stat: Int32
    @NSManaged public var stat: StatInfoEntity?

}

extension StatsEntity : Identifiable {

}
