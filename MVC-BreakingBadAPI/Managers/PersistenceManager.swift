//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum Keys {
    static let favorites = "favorites"
}

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private let userDefaults = UserDefaults.standard
    
    private var favorites: [Character]! = []
    
    func loadFavourite(for characterName: String) -> Bool {
        return userDefaults.bool(forKey: characterName)
    }
    
    func updateFavorites(with character: Character, isFavorite: Bool) {
        userDefaults.set(isFavorite, forKey: character.nickname)

        favorites = self.get()
        if isFavorite {
            if favorites.contains(where: { $0.nickname == character.nickname }) {
                return
            } else {
                favorites.append(character)
            }
        } else {
            if favorites.contains(where: { $0.nickname == character.nickname }) {
                favorites.removeAll { $0.nickname == character.nickname }
            } else {
                return
            }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(favorites), forKey: Keys.favorites)
    }

    func get() -> [Character]! {
        var userData: [Character]!
        if let data = userDefaults.value(forKey: Keys.favorites) as? Data {
            userData = try? PropertyListDecoder().decode([Character].self, from: data)
            return userData!
        } else {
            userData = []
            return userData
        }
    }
}
