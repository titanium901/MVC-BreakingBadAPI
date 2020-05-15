//
//  TextChecker.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 09.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct TextChecker {
    
    var text: String
    var isValid: Bool!
    // зачем статика? зачем unwrap?
//    static var searchValidText: String!
    var searchValidText: String = ""
    
    init(text: String) {
        self.text = text
    }
    
    mutating func checkUserInput(){
        if text.isEmpty {
            isValid = false
        } else {
            isValid = true
            searchValidText = makeStringForSearchRequest(text)
        }
    }
    
    private func makeStringForSearchRequest(_ text: String) -> String {
        return text.trimmingCharacters(in:
            .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "+")
            .lowercased()
            .capitalized
    }
}
