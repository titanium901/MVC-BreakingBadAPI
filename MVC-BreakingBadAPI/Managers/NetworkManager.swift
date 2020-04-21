//
//  NetworkManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://www.breakingbadapi.com/api/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getCharacters(name: String, completed: @escaping (Result<[Character], BBError>) -> Void) {
        let endpoint = baseUrl + "characters"
        
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
}
