//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct FavoritePersistenceManager {
    enum Keys: String {
        case favorites
    }
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

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
