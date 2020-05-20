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
        addSubviews()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews(logoImageView, characterTextField, showAllCharacteButton, searchCharacterButton)
    }
    
    private func layoutUI() {
        [logoImageView,
         characterTextField,
         showAllCharacteButton,
         searchCharacterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            logoImageView.heightAnchor.constraint(equalToConstant: 400),
            
            characterTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            characterTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            characterTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            characterTextField.heightAnchor.constraint(equalToConstant: 50),
            
            showAllCharacteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            showAllCharacteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            showAllCharacteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            showAllCharacteButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchCharacterButton.bottomAnchor.constraint(equalTo: showAllCharacteButton.topAnchor, constant: -20),
            searchCharacterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            searchCharacterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            searchCharacterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
