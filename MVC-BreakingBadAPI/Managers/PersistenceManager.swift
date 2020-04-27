//
//  PersistenceManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 27.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private let userDefaults = UserDefaults()
    
    func saveToFavourite(for characterName: String, with status: Bool) {
        userDefaults.set(status, forKey: characterName)
    }
    
    func loadFavourite(for characterName: String) -> Bool {
        return userDefaults.bool(forKey: characterName)
    }
}
