//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
// можно внести внутрь PersistenceManager
enum Keys {
    static let favorites = "favorites"
}

class PersistenceManager {
    
    static let shared = PersistenceManager()
    // не заприватил init
    
    private let userDefaults = UserDefaults.standard

    // что за unwrap?
    private var favorites: [Character]! = []

    // по названию непонятно почему метод возвращает Bool
    func loadFavourite(for characterName: String) -> Bool {
        return userDefaults.bool(forKey: characterName)
    }
    
    func updateFavorites(with character: Character, isFavorite: Bool) {
        userDefaults.set(isFavorite, forKey: character.nickname)

        favorites = self.get()
        // можно сделать два метода отдельных
        // добавление и удаление из избранного
        if isFavorite {
            // можно вынести метод проверки если в избранном
            guard !favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            favorites.append(character)
        } else {
            guard favorites.contains(where: { $0.nickname == character.nickname }) else { return }
            favorites.removeAll { $0.nickname == character.nickname }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(favorites), forKey: Keys.favorites)
    }

    // что за unwrap?
    // название не говорит о том что возаращается
    func get() -> [Character]! {
        var userData: [Character]! // совсем не нужный массив, можно без него обойтись
        if let data = userDefaults.value(forKey: Keys.favorites) as? Data {
            userData = try? PropertyListDecoder().decode([Character].self, from: data)
            return userData!
        } else {
            userData = []
            return userData
        }
    }
}
