//
//  Favorites.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 10.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

class FavoriteList {

    static var shared = FavoriteList()

    private let persistenceManager = FavoritePersistenceManager()
    
    private(set) var favorites: [Character] {
        didSet {
            save()
            // Notify about changes
            NotificationFavoriteBadge.post()
        }
    }

    private init() {
        favorites = persistenceManager.load()
    }

    private func load() -> [Character] {
        persistenceManager.load()
    }

    private func save() {
        persistenceManager.save(characters: favorites)
    }
}

extension FavoriteList {

    //FavoriteList.shared.isFavorite(character:)
    func isFavorite(character: Character) -> Bool {
        favorites.contains(character)
    }

    func add(character: Character) {
        guard !favorites.contains(character) else { return }
        favorites.append(character)
    }

    func remove(character: Character) {
        guard favorites.contains(character) else { return }
        favorites.removeAll(where: { $0 == character })
    }
}
