//
//  PokemonModel.swift
//  PocketMon
//
//  Created by HoangDus on 02/09/2024.
//

import Foundation

struct Pokémon: Codable, Equatable {
    var id: Int
    var name: String
    var sprites: sprites
    var height: Int
    var stats: [stat]
    var types: [type]
    var weight: Int
    
	var captitalizedName: String{
		return String(name.prefix(1).uppercased() + name.dropFirst())
	}

	var combinedTypeNames: String{
		var typeList: String = ""
	
		if types.count > 1{
			types.forEach{ type in
				if type == types[types.endIndex - 1]{
					typeList.append("\(type.type.name)")
				}else{
					typeList.append("\(type.type.name), ")
				}
			}
			return typeList
		}
		return types[0].type.name
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

struct sprites: Codable, Equatable {
	var back_default: String?
	var back_shiny: String?
	var front_default: String
	var front_shiny: String
    var versions: versions
    var other: other
    
    struct other: Codable, Equatable{
        var showdown: showdown
        
        struct showdown: Codable, Equatable {
            var front_default: String?
        }
    }
    
    struct versions: Codable, Equatable{
        var generationv: genv
        
        struct genv: Codable, Equatable {
            var blackwhite: blackwhite
            
            struct blackwhite: Codable, Equatable {
                var animated: animatedGIF
                
                struct animatedGIF: Codable, Equatable {
                    var front_default: String?
                }
            }
            
            enum CodingKeys: String, CodingKey{
                case blackwhite = "black-white"
            }
            
        }
        
        enum CodingKeys: String, CodingKey{
            case generationv = "generation-v"
        }
    }
    
}

struct stat: Codable, Equatable{
	var base_stat: Int
	var stat: statInfo

	struct statInfo: Codable, Equatable {
		var name: String
		var url: String
	}
}

struct type: Codable, Equatable {
	var slot: Int
	var type: typeInfo
	
	struct typeInfo: Codable, Equatable {
		var name: String
		var url: String
	}
}
