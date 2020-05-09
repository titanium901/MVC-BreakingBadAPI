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
    func catchError(erorr: Error)
}

class NetworkCharactersManager: NSObject {
    
    static let shared = NetworkCharactersManager()
    
    private let jsonDecoder = JSONDecoder()
    
    private var characterObject: Character?
    private var error: Error?
    private var delegate: NetworkManagerDelegate?
    
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

class NetworkCharacterManager: NSObject {
    
    static let shared = NetworkCharacterManager()
    
    private let jsonDecoder = JSONDecoder()
    
    private var characterObject: Character?
    private var error: Error?
    private var delegate: NetworkManagerDelegate?
    
    func getCharacter(name: String, completionHandler: @escaping ([Character], Bool?) -> Void) {
        AF.request("https://www.breakingbadapi.com/api/characters?name=\(name)", method: .get).responseJSON { (response) in
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
