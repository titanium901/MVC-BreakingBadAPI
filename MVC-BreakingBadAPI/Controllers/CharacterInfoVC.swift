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
    
    private let stackView = update(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    private let characterImageView = update(UIImageView()) {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemBackground
        $0.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
    }
    private let activityIndicator = update(UIActivityIndicatorView()) {
        $0.startAnimating()
        $0.style = .large
        $0.color = .systemOrange
    }
    private let characterName = update(UILabel()) {
        $0.applyBBStyle()
    }
    private let characterNickname = update(UILabel()) {
        $0.applyBBStyle()
        $0.textColor = .orange
    }
    private let characterStatus = update(UILabel()) {
        $0.applyBBStyle()
    }
    private let characterPortrayed = update(UILabel()) {
        $0.applyBBStyle()
        $0.textColor = .orange
    }
    private let characterAppearance = update(UILabel()) {
        $0.applyBBStyle()
    }
    private lazy var addToFavoriteButton = update(UIButton()) {
        $0.addTarget(self, action: #selector(self.addDeleteFavoriteButtonTapped), for: .touchUpInside)
    }
    
    var character: Character! {
        didSet {
            configureUIElements(with: character)
            activityIndicator.stopAnimating()
        }
    }

    private let searchRequest: SearchRequest

    init(searchRequest: SearchRequest) {
        self.searchRequest = searchRequest
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        Character.loadCharacter(by: searchRequest.characterName) { [weak self] char, error  in
            guard let self = self else { return }
            guard error == nil else {
                self.ifNetworkError(error: error!)
                return
            }
            guard let char = char else {
                self.characterNotFound(
                    message: self.searchRequest.characterName
                )
                return
            }
            self.character = char
            self.character.loadFavouriteStatus()
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
    
    private func ifNetworkError(error: Error) {
        presentAlert(title: AlertTitle.oops, message: error.localizedDescription, buttonTitle: "ОК")
        showEmptyStateView(with: error.localizedDescription, in: view)
        activityIndicator.stopAnimating()
    }
}
