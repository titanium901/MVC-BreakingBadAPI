//
//  BBEmptyStateView.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 29.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class BBEmptyStateView: UIView {
    
    private let messageLabel = update(UILabel()) {
        $0.applyBBStyle()
        $0.numberOfLines = 3
        $0.textColor = .secondaryLabel
    }
    private let logoImageView = update(UIImageView()) {
        $0.image = Images.bbLogo
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func _setupLayout() {

        addSubview(logoImageView, constraints: [
            equal(\.bottomAnchor),
            equal(\.widthAnchor, constant: 300),
            equal(\.heightAnchor, constant: 300),
            equal(\.trailingAnchor, constant: 50)
        ])
        
        addSubview(messageLabel, constraints: [
            equal(\.centerYAnchor, constant: -150),
            equal(\.leadingAnchor, constant: 40),
            equal(\.trailingAnchor, constant: -40),
            equal(\.heightAnchor, constant: 200)
        ])
    }
}

