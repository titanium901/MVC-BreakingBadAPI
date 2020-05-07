//
//  Characters.swift
//  MVC-BreakingBadAPI
//
//  Created by Sukhanov Evgeniy on 07.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

struct Characters {

    var characters: [Character] = []

    init() {}

    func add(character: Character)
    func add(characters: [Character])
    func remove(character: Character) -> Bool
}

protocol Characters {}
protocol LoadNetworkCharacters {}
protocol LoadDBCharacters {}
