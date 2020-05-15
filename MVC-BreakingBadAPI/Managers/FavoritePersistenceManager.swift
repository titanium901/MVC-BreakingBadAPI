//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

// можно отказаться от синглтона
class FavoritePersistenceManager {
    private init() {}
    
    enum Keys { static let favorites = "favorites" }
    static let shared = FavoritePersistenceManager()
    let userDefaults = UserDefaults.standard
    
    func updateFavorites(with character: Character, isFavorite: Bool) {
        userDefaults.set(isFavorite, forKey: character.nickname)
        if isFavorite {
            guard !FavoriteList.shared.favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            FavoriteList.shared.favorites.append(character)
        } else {
            guard FavoriteList.shared.favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            FavoriteList.shared.favorites.removeAll { $0.nickname == character.nickname }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(FavoriteList.shared.favorites), forKey: Keys.favorites)
    }
}
