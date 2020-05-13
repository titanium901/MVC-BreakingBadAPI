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
    // не понял зачем тебе в итоге это поле
    var isFavorite: Bool?
    
    mutating func loadFavouriteStatus() {
        isFavorite = PersistenceManager.shared.userDefaults.bool(forKey: self.nickname)
    }

    mutating func addFavoriteStatus(){
        isFavorite = false
    }
    
    func updateFavoriteStatusInDB() {
        PersistenceManager.shared.updateFavorites(with: self, isFavorite: self.isFavorite!)
    }

    // static func addFavoriteStatus(to characters: [Character]) -> [Character] {
    static func addFavoriteStatusToAll(to characters : [Character]) -> [Character] {
        var favCharacters: [Character] = []
        for var character in characters {
            character.addFavoriteStatus()
            favCharacters.append(character)
        }
        return favCharacters
    }

    // Эти методы можно положить в Characters
    static func loadCharacter(by name: String, completion: @escaping (Character?) -> Void) {
        NetworkCharacterManager.shared.getCharacter(name: name) { (characters, success) in
            if success == true {
                completion(characters.first ?? nil)
            }
        }
    }
    
    static func loadAllCharacters(completion: @escaping ([Character]?) -> Void) {
        NetworkCharactersManager.shared.getCharacters { (characters, success) in
            if success == true {
                completion(characters)
            }
        }
    }
    
    static func filterCharactersByName(characters: [Character], name: String) -> [Character] {
        characters.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
}

