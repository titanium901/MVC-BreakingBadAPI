//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

// умеет сохранять и загружать список персонажей 
struct FavoritePersistenceManager {
    enum Keys: String {
        case favorites
    }
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // ["id1", "id2"]  [AviaOffer.Id]
    // [Character]  [Sing]

    func save(characters: [Character]) {
        userDefaults.set(
            try? PropertyListEncoder().encode(
                characters
            ),
            forKey: Keys.favorites.rawValue
        )
    }

    func load() -> [Character] {
        if let data = userDefaults.value(forKey: Keys.favorites.rawValue) as? Data {
            return try! PropertyListDecoder().decode([Character].self, from: data)
        }
        else {
            return []
        }
    }
}
