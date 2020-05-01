//
//  NetworkManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

// foundation будет достаточно
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://www.breakingbadapi.com/api/"
    
    private init() {}
    
    func getCharacters(completed: @escaping (Result<[Character], BBError>) -> Void) {
        let endpoint = baseUrl + "characters"

        // раз url задается внутри сервиса,
        // нет смысла проверять его валидность
        // let url = URL(string: endpoint)!
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error { // что это? if error != nil
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let characters = try decoder.decode([Character].self, from: data)
                completed(.success(characters))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getCharacter(name: String, completed: @escaping (Result<[Character], BBError>) -> Void) {
        let endpoint = baseUrl + "characters?name=\(name)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                // создание и конфиг декодера явно дублируется
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let character = try decoder.decode([Character].self, from: data)
                completed(.success(character))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
