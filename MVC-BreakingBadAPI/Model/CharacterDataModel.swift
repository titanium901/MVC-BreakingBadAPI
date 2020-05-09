//
//  DataModel.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

protocol DataModelDelegate: class {
    func didRecieveCharacter(character: Character)
    func notRecieveCharacter()
}

class CharacterDataModel {
    weak var delegate: DataModelDelegate?
    
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
