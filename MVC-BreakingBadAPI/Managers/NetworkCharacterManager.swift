//
//  NetworkCharacterManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkCharacterManager {
    
    static let shared = NetworkCharacterManager()
    
    func getCharacter(name: String, completionHandler: @escaping (Result<[Character], Error>) -> Void) {
        AF.request("https://www.breakingbadapi.com/api/characters?name=\(name)", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let characters = try JSONDecoder().decode([Character].self, from: jsonData)
                        completionHandler(.success(characters))
                    } catch let error {
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
