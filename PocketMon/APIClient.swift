//
//  APIClient.swift
//  PocketMon
//
//  Created by HoangDus on 02/09/2024.
//

import Foundation

final class APIClient{
	static let shared = APIClient()
	
	private let baseAPI = "https://pokeapi.co/api/v2"
	
	//pokémon lookup using name or id number
	func getPokémon(input: String) async throws -> Pokémon?{
		
		if input.isEmpty {
			throw PokéAPIError.noInput
		}
		
		print("searching for: \(input)")
		
		let endpoint: String = "\(baseAPI)/pokemon/\(input)"

		guard let url = URL(string: endpoint) else {
			throw PokéAPIError.invalidURL
		}
		
	//    var url: URL{
	//        var components = URLComponents()
	//        components.host = "pokeapi.co"
	//        components.scheme = "https"
	//        components.path = "/api/v2/pokemon/\(input)"
	//        print(components.url!)
	//        return components.url!
	//    }
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse else {
			throw PokéAPIError.noResponse
		}
		
		if response.statusCode == 200{
			print("ok")
		}else{
			throw PokéAPIError.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(Pokémon.self, from: data)
		}catch{
			throw PokéAPIError.invalidData
		}
		
	}
}

enum PokéAPIError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case noInput
    case noResponse
}
