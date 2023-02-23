//
//  PokemonController.swift
//  Pokedex
//
//  Created by iMac Pro on 2/23/23.
//

import Foundation

class PokemonController {
    
    static func fetchPokemon(searchTerm: String, completion: @escaping (Pokemon?) -> Void) {
//    https://pokeapi.co/api/v2/pokemon/
        guard let baseURL = URL(string: Constants.PokemonURL.baseURL) else { completion(nil) ; return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(searchTerm)
        
        guard let finalPath = urlComponents?.url else { completion(nil) ; return }
        print("Final Pokemon URL: \(finalPath)")
        
        URLSession.shared.dataTask(with: finalPath) { pokeData, response, error in
            if let error = error {
                print("Error in Pokemon Request: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Pokemon Response Status Code: \(response.statusCode)")
            }
            
            guard let data = pokeData else { completion(nil) ; return }
            do {
                if let topLevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any] {
                    let pokemon = Pokemon(pokemonDictionary: topLevel)
                    completion(pokemon)
                }
            } catch {
                print("Unable to retrieve Pokemon data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
