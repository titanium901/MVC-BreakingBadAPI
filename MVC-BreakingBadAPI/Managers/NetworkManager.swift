//
//  NetworkManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkManagerDelegate {
    func characterDataRedy()
    func catchError(erorr: Error)
}

class NetworkCharacterManager: NSObject {
    
    let jsonDecoder = JSONDecoder()
    
    var charactersObject: [Character]?
    var characterObject: Character?
    var error: Error?
    var delegate: NetworkManagerDelegate?
    
    func getCharacters() {
        AF.request("https://www.breakingbadapi.com/api/characters", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let characters = try self.jsonDecoder.decode([Character].self, from: jsonData)
                        self.charactersObject = characters
                        if self.delegate != nil { self.delegate?.characterDataRedy() }
                    } catch let error {
                        if self.delegate != nil { self.delegate?.catchError(erorr: error) }
                    }
                }
            case .failure(let error):
                if self.delegate != nil { self.delegate?.catchError(erorr: error) }
            }
        }
    }
    
    func getCharacterByName(name: String) {
        AF.request("https://www.breakingbadapi.com/api/characters?name=\(name)", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let characters = try self.jsonDecoder.decode([Character].self, from: jsonData)
                        self.characterObject = characters.first
                        if self.delegate != nil { self.delegate?.characterDataRedy() }
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
