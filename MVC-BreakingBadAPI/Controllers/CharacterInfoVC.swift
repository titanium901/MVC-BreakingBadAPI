//
//  CharacterInfoVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit
import SDWebImage

class CharacterInfoVC: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        return imageView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.style = .large
        activity.color = .systemOrange
        return activity
    }()
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.applyBBStyle()
        return label
    }()
    private lazy var characterNickname: UILabel = {
        let label = UILabel()
        label.applyBBStyle()
        label.textColor = .orange
        return label
    }()
    private lazy var characterStatus: UILabel = {
        let label = UILabel()
        label.applyBBStyle()
        return label
    }()
    private lazy var characterPortrayed: UILabel = {
        let label = UILabel()
        label.applyBBStyle()
        label.textColor = .orange
        return label
    }()
    private lazy var characterAppearance: UILabel = {
        let label = UILabel()
        label.applyBBStyle()
        return label
    }()
    private lazy var addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addDeleteFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var character: Character! {
        didSet {
            configureUIElements(with: character)
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        loadCharacter()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadCharacter() {
        guard character == nil else { return }
        Character.loadCharacter(by: TextChecker.searchValidText) { [weak self] char, _  in
            guard let char = char else {
                self?.characterNotFound(message: TextChecker.searchValidText)
                return
            }
            self?.character = char
            self?.character.loadFavouriteStatus()
        }
    }
    
    @objc private func addDeleteFavoriteButtonTapped() {
        character.isFavorite?.toggle()
        let image = character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart")
        addToFavoriteButton.setImage(image, for: .normal)
        character.updateFavoriteStatusInDB()
    }
    
    private func configureUIElements(with character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterAppearance.text = "\(character.appearance)"
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: Images.placeholder)
        
        addToFavoriteButton.setImage(character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart"), for: .normal)
    }
    
    private func layoutUI() {
        view.addSubviews(characterImageView, stackView, addToFavoriteButton, activityIndicator)
        
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
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            characterImageView.heightAnchor.constraint(equalToConstant: 300),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            
            addToFavoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToFavoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            addToFavoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 50),
            addToFavoriteButton.widthAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func characterNotFound(message: String) {
        presentAlert(
            title: AlertTitle.error,
            message: message + " - not found",
            buttonTitle: "ОК"
        )
        
        activityIndicator.stopAnimating()
        characterImageView.isHidden = true
        showEmptyStateView(with: "Empty", in: view)
    }
}
