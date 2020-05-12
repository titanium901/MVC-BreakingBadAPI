//
//  NotificationFavoriteBadge.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 12.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

class NotificationFavoriteBadge {
    
    static func addObserver(with selector: Selector, observer: Any) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .FavoritesBadgeChange, object: nil)
    }
}
