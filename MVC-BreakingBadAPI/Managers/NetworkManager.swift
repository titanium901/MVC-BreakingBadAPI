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
    let jsonDecoder = JSONDecoder()
    
    var error: Error?
    var delegate: NetworkManagerDelegate?
}
