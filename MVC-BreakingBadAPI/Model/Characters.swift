//
//  Characters.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 15.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

class Characters {

    private(set) var characters: Result<[Character], Error> = .success([]) {
        didSet {
            // Notify about changes
        }
    }

//    func sort() -> [Character] {}
//    func filter() -> [Character] {}
//    func getByName() -> Character {}
}

extension Characters {
    func loadAll() {
        // DI
        NetworkCharactersManager.getCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = .success(characters)
            case.failure(let error):
                self?.characters = .failure(error)
            }
        }
    }

    func fetch(name: String) -> [Character] {
        characters.value?.filter {
            $0.name.lowercased().contains(name.lowercased())
        } ?? []
    }
}

extension Result {
    var value: Success? {
        switch self  {
        case .success(let success):
            return success
        case .failure:
            return nil
        }
    }
}
