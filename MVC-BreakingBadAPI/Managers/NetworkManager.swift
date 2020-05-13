//
//  NetworkManager.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkManagerDelegate {
    func catchError(erorr: Error)
}

class NetworkManager: NSObject {
    // а есть смысл хранить декодер?
    let jsonDecoder = JSONDecoder()

    // это поле вообще используется?
    var error: Error?
    // делегаты всегда weak
    // и он вроде тут не особо нужен,
    // а то у тебя результат из одной дырки вылетает а ошибка из другой
    var delegate: NetworkManagerDelegate?
}
