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
    
    func saveToFavourite(for characterName: String, with status: Bool) {
        userDefaults.set(status, forKey: characterName)
    }
    
    func loadFavourite(for characterName: String) -> Bool {
        return userDefaults.bool(forKey: characterName)
    }

    func save(character: Character) {
        favorites = self.get()
        if favorites.contains(character) {
            return
        } else {
            favorites.append(character)
            userDefaults.set(try? PropertyListEncoder().encode(favorites), forKey: Keys.favorites)
        }
    }
    
    func remove(character: Character) {
        favorites = self.get()
        if favorites.contains(character) {
            favorites.removeAll { $0 == character}
            userDefaults.set(try? PropertyListEncoder().encode(favorites), forKey: Keys.favorites)
        } else {
            return
        }
    }

    func get() -> [Character]! {
        var userData: [Character]!
        if let data = userDefaults.value(forKey: Keys.favorites) as? Data {
            userData = try? PropertyListDecoder().decode([Character].self, from: data)
            return userData!
        } else {
            return userData
        }
    }
}
