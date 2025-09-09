//
//  PokemonSearchScreen.swift
//  PocketMon
//
//  Created by HoangDus on 03/09/2024.
//

import SwiftUI

struct PokemonSearchView: View {
    
	@StateObject var pokemonSearchViewModel = PokemonSearchViewModel()
	@FocusState private var isTextFieldFocused: Bool
	
    var body: some View {
        VStack(spacing: 10){
            HStack{
				TextField("Search a Pokémon", text: $pokemonSearchViewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .environment(\.colorScheme, .light)
                    .accentColor(appAccentColor)
                    .font(.system(size: 25))
					.focused($isTextFieldFocused)
                    .autocorrectionDisabled()
                Button(
                    action: {
						isTextFieldFocused = false
						pokemonSearchViewModel.searchPokémon(input: pokemonSearchViewModel.searchText)
                    },
                    label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                )
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(appAccentColor))
            }
            Button(
                action: {
					isTextFieldFocused = false
					pokemonSearchViewModel.searchText = ""
					pokemonSearchViewModel.getRandomPokémon()
                },
                label: {
                    Label("Random Pokémon", systemImage: "").font(.system(size: 20)).labelStyle(.titleOnly)
                }
            )
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(appAccentColor))
            .accentColor(.white)
			PokemonSearchResultView(pokémon: pokemonSearchViewModel.pokémon)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(appPrimaryColor)
        .ignoresSafeArea()
		.onTapGesture {
			isTextFieldFocused = false
		}
    }
}

struct PokemonSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSearchView()
    }
}

