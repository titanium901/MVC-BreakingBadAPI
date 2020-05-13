//
//  SearchValidRequest.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

// Эта штука явно не должна быть синглтоном
class SearchValidRequest {
    static let shared = SearchValidRequest()
    private init() {}
    
    var validName: String!
}
