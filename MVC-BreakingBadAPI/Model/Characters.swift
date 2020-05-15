//
//  Characters.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 15.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct Characters {
    
    static func loadAllCharacters(completion: @escaping ([Character]?) -> Void) {
        NetworkCharactersManager.shared.getCharacters { (characters, success) in
            if success == true {
                completion(characters)
            }
        }
    }
    
    static func filterCharactersByName(characters: [Character], name: String) -> [Character] {
        characters.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
}
