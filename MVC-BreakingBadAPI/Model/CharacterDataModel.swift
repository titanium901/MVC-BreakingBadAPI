//
//  DataModel.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
//Пока просто оставлю, как пример для себя как ходить в сеть не через модель

protocol CharacterDataModelDelegate: class {
    func didRecieveCharacter(character: Character)
    func notRecieveCharacter()
}

class DataModel {
    weak var delegate: CharacterDataModelDelegate?
    
    func loadCharacter(by name: String) {
//        NetworkCharacterManager.shared.getCharacter(name: name) { (character, success) in
//            if success == true {
//                guard !character.isEmpty else {
//                    self.delegate?.notRecieveCharacter()
//                    return
//                }
//                self.delegate?.didRecieveCharacter(character: character.first!)
//            }
//        }
    }
}
