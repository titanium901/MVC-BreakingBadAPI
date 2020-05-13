//
//  DataModel.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

protocol CharacterDataModelDelegate: class {
    func didRecieveCharacter(character: Character)
    func notRecieveCharacter()
}

// Название не говорит о сути и перекликается с Character
class CharacterDataModel {
    weak var delegate: CharacterDataModelDelegate?
    
    func loadCharacter(by name: String) {
        NetworkCharacterManager.shared.getCharacter(name: name) { (character, success) in
            if success == true {
                guard !character.isEmpty else {
                    self.delegate?.notRecieveCharacter()
                    return
                }
                self.delegate?.didRecieveCharacter(character: character.first!)
            }
        }
    }
}
