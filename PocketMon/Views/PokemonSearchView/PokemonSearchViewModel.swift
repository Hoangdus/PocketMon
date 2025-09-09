//
//  PokemonSearchViewModel.swift
//  PocketMon
//
//  Created by HoangDus on 01/06/2025.
//

import Foundation

final class PokemonSearchViewModel: ObservableObject{
	@Published var pokémon: Pokémon?
	@Published var searchText = ""
	
	private let apiClient = APIClient.shared
	
	func searchPokémon(input: String){
		pokémon = nil
		DispatchQueue.main.async {
			Task{
				do {
					self.pokémon = try await self.apiClient.getPokémon(input: "\(input.lowercased())")
//                    print("B&W ani'd sprite: \(self.pokémon?.sprites.versions.generationv.blackwhite.animated.front_default)")
//                    print("Showdown sprite: \(self.pokémon?.sprites.other.showdown.front_default)")
				}catch PokéAPIError.invalidResponse{
					print("wrong response")
				}catch PokéAPIError.invalidData{
					print("invalid Data")
				}catch PokéAPIError.invalidURL{
					print("invaild URL")
				}catch PokéAPIError.noResponse{
					print("no response from server")
				}catch{
					print("something else is fucked")
				}
			}
		}
	}
	
	func getRandomPokémon(){
		searchPokémon(input: "\(Int.random(in: 1...1025))")
	}
}
