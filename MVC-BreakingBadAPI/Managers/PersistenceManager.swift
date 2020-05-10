//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    private init() {}
    
    static let shared = PersistenceManager()
    
    let userDefaults = UserDefaults.standard
    
    private var favorites: [Character] = []
    
    func loadFavouriteStatus(for characterName: String) -> Bool {
        return userDefaults.bool(forKey: characterName)
    }
    
    func updateFavorites(with character: Character, isFavorite: Bool) {
        userDefaults.set(isFavorite, forKey: character.nickname)

        favorites = FavoriteList.loadFavorites()
        if isFavorite {
            guard !favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            favorites.append(character)
        } else {
            guard favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            favorites.removeAll { $0.nickname == character.nickname }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(favorites), forKey: Keys.favorites)
    }
}
