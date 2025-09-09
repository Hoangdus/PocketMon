//
//  AllPokemonListVIew.swift
//  PocketMon
//
//  Created by HoangDus on 01/09/2024.
//

import SwiftUI

struct FavPokemonListVIew: View {
	@Environment(\.managedObjectContext) private var moc
	@State var favPokemons: [PokemonEntity] = []
	@ObservedObject var favPokemonListViewModel = FavPokemonViewModel()
	
    var body: some View {
        ScrollView(){
            LazyVStack(){
				ForEach(favPokemonListViewModel.favedPokemons){ value in
					PokemonListItem(pokémon: value, context: moc, action: {
						favPokemonListViewModel.unFavAPokemon(pokemon: value)
					})
                }
            }.padding(10)
        }
		.clipped()
		.background(appPrimaryColor)
		.onAppear(){
			favPokemonListViewModel.getFavedPokemon()
		}
        .onDisappear(){
//            favPokemonListViewModel.favedPokemons.removeAll(keepingCapacity: true)
        }
    }
}

struct FavPokemonListVIew_Previews: PreviewProvider {
    static var previews: some View {
        FavPokemonListVIew()
    }
}
