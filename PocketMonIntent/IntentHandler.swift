//
//  IntentHandler.swift
//  PocketMonIntent
//
//  Created by HoangDus on 31/8/25.
//

import Intents
import CoreData

class IntentHandler: INExtension, ConfigIntentHandling{

    override func handler(for intent: INIntent) -> Any {
        return self
      }
    
    func provideSelectedPokemonOptionsCollection(for intent: ConfigIntent,
                                            with completion: @escaping (INObjectCollection<DisplayedPokemon>?, Error?) -> Void) {
            
            let options = fetchCoreDataOptions()
            let collection = INObjectCollection(items: options)
            completion(collection, nil)
    }
        
    private func fetchCoreDataOptions() -> [DisplayedPokemon] {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                let option = DisplayedPokemon(identifier: "\(entity.id)", display: entity.name)
                option.gifImageURL = entity.gifURL
                return option
            }
        } catch {
            return [
                DisplayedPokemon(identifier: "1", display: "\(error)")
            ]
        }
    }
}
