//
//  GetDailyPokemon.swift
//  DailyPokemonWidgetExtension
//
//  Created by HoangDus on 7/9/25.
//

import Foundation

func getDailyPokemon(completion: @escaping (_ imageData: Data?, _ pokemon: Pokémon?, Error?) -> Void){
    
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1025))"

    print(urlString)
    
    APICaller(url: URL(string: urlString)!){ data, error in
        if error != nil{
            completion(nil, nil, error)
        }

        var pokemonData: Pokémon
        let decoder = JSONDecoder()
        
        if data != nil{
            do {
                pokemonData = try decoder.decode(Pokémon.self, from: data!)
                let bwAnimatedSpriteURL: String? = pokemonData.sprites.versions.generationv.blackwhite.animated.front_default
                let showdownAnimatedSpriteURL: String? = pokemonData.sprites.other.showdown.front_default
                let frontSpriteURL = pokemonData.sprites.front_default
                if bwAnimatedSpriteURL != nil{
                    APICaller(url: URL(string: bwAnimatedSpriteURL!)!){ data, error in
                        if error != nil{
                            completion(nil, nil, error)
                        }
                        var imageData: Data
                        imageData = data!
                        
                        completion(imageData, pokemonData, nil)
                    }
                }else if (showdownAnimatedSpriteURL != nil){
                    APICaller(url: URL(string: showdownAnimatedSpriteURL!)!){ data, error in
                        if error != nil{
                            completion(nil, nil, error)
                        }
                        var imageData: Data
                        imageData = data!
                        
                        completion(imageData, pokemonData, nil)
                    }
                }else{
                    APICaller(url: URL(string: frontSpriteURL)!){ data, error in
                        if error != nil{
                            completion(nil, nil, error)
                        }
                        var imageData: Data
                        imageData = data!
                        
                        completion(imageData, pokemonData, nil)
                    }
                }
            } catch {
                completion(nil, nil, error)
            }
        }
    }
    
    
}

func APICaller(url: URL, completion: @escaping (Data?, Error?) -> Void){
    let session = URLSession.shared
    session.dataTask(with: url){ data, response, error in
        
        if error != nil {
            completion(nil, error)
        }
        
        if let response = response as? HTTPURLResponse{
            print(response.statusCode)
        }
        
        if data != nil {
            completion(data!, nil)
//            Task{
//                await session.reset()
//            }
        }
    }.resume()
}
