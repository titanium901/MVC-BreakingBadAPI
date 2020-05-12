//
//  NetworkCharactersManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkCharactersManager: NetworkManager {
    
    static let shared = NetworkCharactersManager()
    
    func getCharacters(completionHandler: @escaping ([Character], Bool?) -> Void) {
        AF.request("https://www.breakingbadapi.com/api/characters", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let characters = try self.jsonDecoder.decode([Character].self, from: jsonData)
                        completionHandler(characters, true)
                    } catch let error {
                        if self.delegate != nil { self.delegate?.catchError(erorr: error) }
                    }
                }
            case .failure(let error):
                if self.delegate != nil { self.delegate?.catchError(erorr: error) }
            }
        }
    }
}
