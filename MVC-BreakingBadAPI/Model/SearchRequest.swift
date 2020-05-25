//
//  SearchRequest.swift
//  MVC-BreakingBadAPI
//
//  Created by Sukhanov Evgeniy on 15.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

struct SearchRequest {

    let characterName: String!

    var isValid: Bool {
        characterName.isEmpty 
    }

    var query: String {
        characterName?.trimmingCharacters(in:
            .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "+")
            .lowercased()
            .capitalized ?? ""
    }
}
