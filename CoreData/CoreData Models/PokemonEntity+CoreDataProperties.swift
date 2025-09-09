//
//  PokemonEntity+CoreDataProperties.swift
//  PocketMon
//
//  Created by HoangDus on 31/8/25.
//
//

import Foundation
import CoreData


extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }

    @NSManaged public var height: Int32
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var weight: Int32
    @NSManaged public var gifURL: String
    @NSManaged public var sprites: SpritesEntity
    @NSManaged public var stats: NSSet
    @NSManaged public var types: NSSet

    var typeArray: [TypeEntity]{
        return types.allObjects as? [TypeEntity] ?? []
    }
    
    var captitalizedName: String{
        return String(name.prefix(1).uppercased() + name.dropFirst())
    }

    var combinedTypeNames: String{
        var typeList: String = ""
        
        if typeArray.count > 0{
            typeArray.forEach{ type in
                if type == typeArray[typeArray.endIndex - 1]{
                    typeList.append(type.type!.name!)
                }else{
                    typeList.append("\(type.type!.name!), ")
                }
            }
            return typeList
        }
        return "test"
    }
    
    var combinedSpriteLinks: [String] {
        var imageLinks: [String] = []
                
        if sprites.back_default != nil {
            imageLinks.append(sprites.front_default)
            imageLinks.append(sprites.back_default!)
            imageLinks.append(sprites.front_shiny)
            imageLinks.append(sprites.back_shiny!)
        }else{
            imageLinks.append(sprites.front_default)
            imageLinks.append(sprites.front_shiny)
        }
        
        return imageLinks
    }
    
}

// MARK: Generated accessors for stats
extension PokemonEntity {

    @objc(addStatsObject:)
    @NSManaged public func addToStats(_ value: StatEntity)

    @objc(removeStatsObject:)
    @NSManaged public func removeFromStats(_ value: StatEntity)

    @objc(addStats:)
    @NSManaged public func addToStats(_ values: NSSet)

    @objc(removeStats:)
    @NSManaged public func removeFromStats(_ values: NSSet)

}

// MARK: Generated accessors for types
extension PokemonEntity {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: TypeEntity)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: TypeEntity)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}

extension PokemonEntity : Identifiable {

}
