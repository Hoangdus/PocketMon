//
//  StatInfoEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 17/06/2025.
//
//

import Foundation
import CoreData


extension StatInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatInfoEntity> {
        return NSFetchRequest<StatInfoEntity>(entityName: "StatInfoEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension StatInfoEntity : Identifiable {

}
