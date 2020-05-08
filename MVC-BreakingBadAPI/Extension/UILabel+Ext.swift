//
//  BBTitleLabel.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 22.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

extension UILabel {
    func applyBBStyle(textColor: UIColor) {
        self.textColor = textColor
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    func applyBBStyleForBBCell(textColor: UIColor, fontSize: CGFloat) {
        self.textColor = textColor
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        textAlignment = .center
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
}
