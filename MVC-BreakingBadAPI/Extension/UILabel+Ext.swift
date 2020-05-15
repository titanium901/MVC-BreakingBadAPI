//
//  BBTitleLabel.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 22.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

extension UILabel {
    func applyBBStyle() {
        adjustsFontSizeToFitWidth = true
        textColor = .label
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    func applyBBStyleForBBCell() {
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        textColor = .label
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        textAlignment = .center
    }
}
