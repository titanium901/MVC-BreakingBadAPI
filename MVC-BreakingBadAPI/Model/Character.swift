//
//  Character.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct Character: Codable {
    let char_id: Int
    let name: String
    let birthday: String
    let img: String
    let nickname: String
    let portrayed: String
}
