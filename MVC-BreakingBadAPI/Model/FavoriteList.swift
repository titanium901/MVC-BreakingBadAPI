//
//  Favorites.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 10.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct FavoriteList {
    
    static var shared = FavoriteList()
    
    var favorites: [Character] = loadFavorites() {
        didSet {
            NotificationFavoriteBadge.post()
        }
    }
    
    private static func loadFavorites() -> [Character] {
        if let data = FavoritePersistenceManager.shared.userDefaults.value(forKey: FavoritePersistenceManager.Keys.favorites) as? Data {
            return try! PropertyListDecoder().decode([Character].self, from: data)
        }
        else {
            return []
        }
    }
}
