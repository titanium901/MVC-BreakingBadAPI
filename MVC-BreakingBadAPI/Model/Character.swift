//
//  Character.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct Character: Codable, Hashable {
    let name: String
    let occupation: [String]
    let img: String
    let status: String
    let nickname: String
    let appearance: [Int]
    let portrayed: String
    var isFavorite: Bool?
    
    var characters: [Character]?
    
    mutating func loadFavouriteStatus() {
        isFavorite = PersistenceManager.shared.loadFavouriteStatus(for: String(nickname))
    }
    
    mutating func addFavoriteStatus(){
        isFavorite = false
    }
    
    static func loadCharacter(by name: String, completion: @escaping (Character?) -> Void) {
        NetworkCharacterManager.shared.getCharacter(name: name) { (characters, success) in
            if success == true {
                completion(characters.first ?? nil)
            }
        }
    }
}

