//
//  LocalPokemonRepository.swift
//  PocketMon
//
//  Created by HoangDus on 15/06/2025.
//

import Foundation
import CoreData

final class LocalPokemonRepository{
	private var context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func entityExistsByID(with id: Int) -> Bool {
		let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == \(id)")
			
		do {
			let count = try context.count(for: fetchRequest)
			return count > 0
		} catch {
			print("Error checking entity existence: \(error)")
			return false
		}
	}
	
	func favoriteAPokemon(newFavPokemon: Pokémon){
		let pokemon = PokemonEntity(context: context)
		let sprites = SpritesEntity(context: context)
				
		let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        guard let sharedContainerPath = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.hoangdus.pocketmon"
        ) else {
            fatalError("App group not init'd")
        }
        
        downloadFile(from: URL(string: newFavPokemon.sprites.front_default)!, saveLocation: sharedContainerPath, fileName: "\(newFavPokemon.name)_front_default.png", completion: {_,_ in})
        
        let gifURL = newFavPokemon.sprites.versions.generationv.blackwhite.animated.front_default
        
        if(gifURL != nil){
            downloadFile(from: URL(string: gifURL!)!, saveLocation: sharedContainerPath, fileName: "\(newFavPokemon.name).gif", completion: {_,_ in})
        }
        
        downloadFile(from: URL(string: newFavPokemon.sprites.front_default)!, saveLocation: documentsPath, fileName: "\(newFavPokemon.name)_front_default.png", completion: {_,_ in})
		
        downloadFile(from: URL(string: newFavPokemon.sprites.front_shiny)!, saveLocation: documentsPath, fileName: "\(newFavPokemon.name)_front_shiny.png", completion: {_,_ in})
		
		if(newFavPokemon.sprites.back_default != nil){
            downloadFile(from: URL(string: newFavPokemon.sprites.back_default!)!, saveLocation: documentsPath, fileName: "\(newFavPokemon.name)_back_default.png", completion: {_,_ in})
			
            downloadFile(from: URL(string: newFavPokemon.sprites.back_shiny!)!, saveLocation: documentsPath, fileName: "\(newFavPokemon.name)_back_shiny.png", completion: {_,_ in})
			
			sprites.back_default = "\(newFavPokemon.name)_back_default.png"
			sprites.back_shiny = "\(newFavPokemon.name)_back_shiny.png"
		}
	
		sprites.front_default = "\(newFavPokemon.name)_front_default.png"
		sprites.front_shiny = "\(newFavPokemon.name)_front_shiny.png"
		
		pokemon.id = Int32(newFavPokemon.id)
		pokemon.name = newFavPokemon.captitalizedName
		pokemon.height = Int32(newFavPokemon.height)
		pokemon.weight = Int32(newFavPokemon.weight)
		pokemon.sprites = sprites
        pokemon.gifURL = "\(newFavPokemon.name).gif"
		
		for statItem in newFavPokemon.stats{
			let stat = StatEntity(context: context)
			let statInfo = StatInfoEntity(context: context)
			statInfo.name = statItem.stat.name
			statInfo.url = statItem.stat.url
			
			stat.base_stat = Int32(statItem.base_stat)
			stat.stat = statInfo
			//			print("stat item: \(statInfo)")
			//			print("stats: \(stat)")
			pokemon.addToStats(stat)
		}
		
		for typeItem in newFavPokemon.types{
			let type = TypeEntity(context: context)
			let typeInfo = TypeInfoEntity(context: context)
			typeInfo.name = typeItem.type.name
			typeInfo.url = typeItem.type.url
			
			type.slot = Int32(typeItem.slot)
			type.type = typeInfo
			pokemon.addToTypes(type)
		}
		
		do {
//			print("pokemon data: \(pokemon)")
			try context.save()
			context.reset()
		} catch {
			context.reset()
			print("error: \(error)")
		}
	}
	
	func getFavoritedPokemons() -> [PokemonEntity]{
		let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
		
		do {
//            context.reset()
			let pokemonEntities = try context.fetch(request)
			return pokemonEntities
		} catch {
			print("Fetch pokemon error: \(error)")
			return []
		}
	}
	
	func unFavoriteAPokemon(pokemonID: Int32){
//        var existingPokemon: PokemonEntity
        
		do {
			let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "id == \(pokemonID)")
			fetchRequest.fetchLimit = 1
			
			let existingPokemon = try context.fetch(fetchRequest)[0]
			self.context.delete(existingPokemon)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            guard let sharedContainerPath = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.hoangdus.pocketmon"
            ) else {
                fatalError("App group not init'd")
            }
            
            do {
                try FileManager.default.removeItem(at: sharedContainerPath.appendingPathComponent(existingPokemon.gifURL, conformingTo: .url))
                try FileManager.default.removeItem(at: documentsPath.appendingPathComponent(existingPokemon.sprites.front_default, conformingTo: .url))
                try FileManager.default.removeItem(at: documentsPath.appendingPathComponent(existingPokemon.sprites.front_shiny, conformingTo: .url))
                
                if(existingPokemon.sprites.back_default != nil){
                    try FileManager.default.removeItem(at: documentsPath.appendingPathComponent(existingPokemon.sprites.back_default!, conformingTo: .url))
                    try FileManager.default.removeItem(at: documentsPath.appendingPathComponent(existingPokemon.sprites.back_shiny!, conformingTo: .url))
                }
                
            } catch {
                print(error)
            }
            
			Task(priority: .background){
				try await self.context.perform{
					try self.context.save()
				}
			}
		} catch {
			print(error)
		}
        
	}
}
