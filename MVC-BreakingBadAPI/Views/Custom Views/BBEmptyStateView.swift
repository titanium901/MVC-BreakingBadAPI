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
        addSubviews()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func addSubviews() {
        addSubview(messageLabel)
        addSubview(logoImageView)
    }
    
    private func layoutUI() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        logoImageViewBottomConstraint.isActive = true
        
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150)
        messageLabelCenterYConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

