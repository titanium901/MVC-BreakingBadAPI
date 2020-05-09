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
        return imageView
    }()
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .label)
        return label
    }()
    private lazy var characterNickname: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .systemOrange)
        return label
    }()
    private lazy var characterStatus: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .label)
        return label
    }()
    private lazy var characterPortrayed: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .systemOrange)
        return label
    }()
    private lazy var characterAppearance: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .label)
        return label
    }()
    private lazy var addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addDeleteFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let characterData = CharacterDataModel()
    var character: Character! {
        didSet {
            configureUIElements(with: character)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        characterData.delegate = self
        characterData.loadCharacter(by: SearchValidRequest.shared.validText)
        lauoutUI()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureUIElements(with character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterAppearance.text = "\(character.appearance)"
        
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: Images.placeholder)
        
        addToFavoriteButton.setImage(character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart"), for: .normal)
    }
    
    private func lauoutUI() {
        view.addSubviews(characterImageView, stackView, addToFavoriteButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        characterName.translatesAutoresizingMaskIntoConstraints = false
        characterNickname.translatesAutoresizingMaskIntoConstraints = false
        characterStatus.translatesAutoresizingMaskIntoConstraints = false
        characterPortrayed.translatesAutoresizingMaskIntoConstraints = false
        characterAppearance.translatesAutoresizingMaskIntoConstraints = false

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
            addToFavoriteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func characterNotFound(message: String) {
        presentAlert(
            title: AlertTitle.error,
            message: message + " - not found",
            buttonTitle: "ОК"
        )
        
        characterImageView.isHidden = true
        showEmptyStateView(with: "Empty", in: view)
    }
    
    @objc private func addDeleteFavoriteButtonTapped() {
        character.isFavorite?.toggle()
        let image = character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart")
        addToFavoriteButton.setImage(image, for: .normal)
        //to do
        PersistenceManager.shared.updateFavorites(with: character, isFavorite: character.isFavorite!)
    }
}

extension CharacterInfoVC: CharacterDataModelDelegate {
    func notRecieveCharacter() {
        characterNotFound(message: SearchValidRequest.shared.validText)
    }
    
    func didRecieveCharacter(character: Character) {
        self.character = character
        self.character.loadFavouriteStatus()
    }
}
