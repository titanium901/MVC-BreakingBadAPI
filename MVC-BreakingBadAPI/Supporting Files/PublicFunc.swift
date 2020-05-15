//
//  PublicFunc.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 15.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

public func update<A>(_ a: A, _ fs: ((inout A) -> Void)...) -> A {
    var a = a
    fs.forEach { f in f(&a) }
    return a
}
