//
//  CharacterInfoView.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit
import SDWebImage

class CharacterInfoView: UIView {
    
    private lazy var stackView = update(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    lazy var characterImageView = update(UIImageView()) {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemBackground
        $0.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
    }
    lazy var activityIndicator = update(UIActivityIndicatorView()) {
        $0.startAnimating()
        $0.style = .large
        $0.color = .systemOrange
    }
    private lazy var characterName = update(UILabel()) {
        $0.applyBBStyle()
    }
    private lazy var characterNickname = update(UILabel()) {
        $0.applyBBStyle()
        $0.textColor = .orange
    }
    private lazy var characterStatus = update(UILabel()) {
        $0.applyBBStyle()
    }
    private lazy var characterPortrayed = update(UILabel()) {
        $0.applyBBStyle()
        $0.textColor = .orange
    }
    private lazy var characterAppearance = update(UILabel()) {
        $0.applyBBStyle()
    }
    lazy var addToFavoriteButton = update(UIButton()) {
        $0.tintColor = .blue
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
        addSubviews(characterImageView, stackView, addToFavoriteButton, activityIndicator)
    }
    
    private func layoutUI() {
        [characterImageView,
         stackView,
         addToFavoriteButton,
         activityIndicator
            ].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
        }

        stackView.addArrangedSubview(characterName)
        stackView.addArrangedSubview(characterNickname)
        stackView.addArrangedSubview(characterStatus)
        stackView.addArrangedSubview(characterPortrayed)
        stackView.addArrangedSubview(characterAppearance)

        // глянь как верстается в ПТТ (своя реализация)
        // сделать Core frameworks
        // SnapKit
        // ...
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            characterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            characterImageView.heightAnchor.constraint(equalToConstant: 300),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),

            stackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200),

            addToFavoriteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToFavoriteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            addToFavoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 50),
            addToFavoriteButton.widthAnchor.constraint(equalToConstant: 50),

            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func configureUIElements(with character: Character, favoriteList: FavoriteList) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterAppearance.text = "\(character.appearance)"
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: Images.placeholder)
        
        activityIndicator.stopAnimating()
        addToFavoriteButton.setImage(
            favoriteList.isFavorite(character: character) ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart"),
            for: .normal
        )
    }
}
