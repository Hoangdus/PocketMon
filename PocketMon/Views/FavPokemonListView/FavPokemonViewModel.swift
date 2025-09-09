//
//  FavPokemonViewModel.swift
//  PocketMon
//
//  Created by HoangDus on 13/06/2025.
//

import Foundation
import CoreData

final class FavPokemonViewModel: ObservableObject{
	@Published var favedPokemons: [PokemonEntity] = []
	private let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
	private let localPokemonRepository: LocalPokemonRepository
	
	init(){
		localPokemonRepository = LocalPokemonRepository(context: context)
	}
	
	func getFavedPokemon(){
		self.favedPokemons = localPokemonRepository.getFavoritedPokemons()
	}
	
	func unFavAPokemon(pokemon: PokemonEntity){
//		favedPokemons.remove(at: favedPokemons.firstIndex(of: pokemon)!)
		localPokemonRepository.unFavoriteAPokemon(pokemonID: pokemon.id)
		getFavedPokemon()
	}
}
