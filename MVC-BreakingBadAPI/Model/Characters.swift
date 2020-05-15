//
//  Characters.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 15.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct Characters {
    
    static func loadAllCharacters(completion: @escaping ([Character]?, Error?) -> Void) {
        NetworkCharactersManager.getCharacters { result in
            switch result {
            case .success(let characters):
                completion(characters, nil)
            case.failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func filterCharactersByName(characters: [Character], name: String) -> [Character] {
        characters.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
}

// отказаться от статики можно например так
//struct Characters {
//    var characters: [Character] = []
//
//    func loadAllCharacters(completion: @escaping (Error?) -> Void) {
//        NetworkCharactersManager.getCharacters { result in
//            switch result {
//            case .success(let characters):
//                self.characters = characters
//                completion(nil)
//            case.failure(let error):
//                completion(error)
//            }
//        }
//    }
//
//    func filterCharactersByName(name: String) -> [Character] {
//        characters.filter { $0.name.lowercased().contains(name.lowercased()) }
//    }
//}
