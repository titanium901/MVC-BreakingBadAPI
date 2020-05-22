//
//  SearchInfoView.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class SearchInfoView: UIView {
    
    private let logoImageView = update(UIImageView()) {
        $0.image = Images.bbLogo
    }
    lazy var characterTextField = update(UITextField()) {
        $0.applyBBStyle()
        $0.placeholder = "Enter a Character Name"
    }
    lazy var searchCharacterButton = update(UIButton()) {
        $0.applyBBStyle()
        $0.setTitle("Search", for: .normal)
        $0.backgroundColor = .orange
    }
    lazy var showAllCharacteButton = update(UIButton()){
        $0.applyBBStyle()
        $0.setTitle("Show All Characters", for: .normal)
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupLayout() {
        
        addSubview(logoImageView, constraints: [
            equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 10),
            equal(\.leadingAnchor, constant: 0),
            equal(\.trailingAnchor, constant: 0),
            equal(\.heightAnchor, constant: 400)
        ])
        
        addSubview(characterTextField, constraints: [
            equal(\.topAnchor, to: logoImageView, \.bottomAnchor, constant: 50),
            equal(\.leadingAnchor, constant: 50),
            equal(\.trailingAnchor, constant: -50),
            equal(\.heightAnchor, constant: 50)
        ])
        
        addSubview(showAllCharacteButton, constraints: [
            equal(\.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            equal(\.leadingAnchor, constant: 50),
            equal(\.trailingAnchor, constant: -50),
            equal(\.heightAnchor, constant: 50)
        ])
        
        addSubview(searchCharacterButton, constraints: [
            equal(\.bottomAnchor, to: showAllCharacteButton, \.topAnchor, constant: -20),
            equal(\.leadingAnchor, constant: 50),
            equal(\.trailingAnchor, constant: -50),
            equal(\.heightAnchor, constant: 50)
        ])
    }
}
