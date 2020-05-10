//
//  Favorites.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 10.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

class FavoriteList {
    
    static let shared = FavoriteList()
    
    var favorites: [Character] = []
    
    static func loadFavorites() {
        if let data = PersistenceManager.shared.userDefaults.value(forKey: PersistenceManager.Keys.favorites) as? Data {
            FavoriteList.shared.favorites =  try! PropertyListDecoder().decode([Character].self, from: data)
        } else {
            FavoriteList.shared.favorites = []
        }
    }
}
