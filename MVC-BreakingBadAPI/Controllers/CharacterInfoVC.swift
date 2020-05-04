//
//  CharacterInfoVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit
import SDWebImage

class CharacterInfoVC: UIViewController, NetworkManagerDelegate {
    
    let stackView = UIStackView()
    let characterImageView = BBImage(frame: .zero)
    let addToFavoriteButton = UIButton(frame: .zero)
    let activityIndicator = UIActivityIndicatorView()
    
    let characterName = BBTitleLabel(textAlignment: .center, fontSize: 26)
    let characterNickname = BBTitleLabel(textAlignment: .center, fontSize: 26, textColor: .systemOrange)
    let characterStatus = BBTitleLabel(textAlignment: .center, fontSize: 26)
    let characterPortrayed = BBTitleLabel(textAlignment: .center, fontSize: 26, textColor: .systemOrange)
    let characterAppearance = BBTitleLabel(textAlignment: .center, fontSize: 26)
    
    var character: Character!
    var userNameInput: String!
    let network = NetworkCharacterManager()
    
    init(userNameInput: String) {
        super.init(nibName: nil, bundle: nil)
        self.userNameInput = userNameInput
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStackView()
        lauoutUI()
        configureaddToFavoriteButton()
        configureActivityIndicator()
        getCharacterInfo()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard character != nil else { return }
        setImageForFavoriteButton()
    }
    
    private func getCharacterInfo() {
        network.delegate = self
        network.getCharacterByName(name: userNameInput)
    }
    
    func characterDataRedy() {
        guard let character = network.characterObject else {
            self.characterNotFound(
                message: "Could not find such a character - \n\(self.userNameInput!.replacingOccurrences(of: "+", with: " "))"
            )
            return
        }
        self.character = character
        DispatchQueue.main.async { self.configureUIElements(with: self.character) }
    }
    
    func catchError(erorr: Error) {
        characterNotFound(message: erorr.localizedDescription)
    }
    
    private func configureUIElements(with character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterAppearance.text = "\(character.appearance)"
        
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: Images.placeholder)
        
        self.character.loadFavouriteStatus()
        
        setImageForFavoriteButton()
        addToFavoriteButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
    }
    
    private func configureaddToFavoriteButton() {
        addToFavoriteButton.addTarget(self, action: #selector(addDeleteFavoriteButtonTapped), for: .touchUpInside)
        addToFavoriteButton.isEnabled = false
    }
    
    private func lauoutUI() {
        view.addSubviews(characterImageView, stackView, addToFavoriteButton, activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
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
            message: message,
            buttonTitle: "ОК"
        )
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.characterImageView.isHidden = true
            self.showEmptyStateView(with: "Empty", in: self.view)
        }
    }
    
    @objc func addDeleteFavoriteButtonTapped() {
        character.isFavorite?.toggle()
        let image = imageForFavoriteButton()
        addToFavoriteButton.setImage(image, for: .normal)
        PersistenceManager.shared.updateFavorites(with: character, isFavorite: character.isFavorite!)
    }
    
    private func setImageForFavoriteButton() {
        self.character.loadFavouriteStatus()
        addToFavoriteButton.setImage(character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart"), for: .normal)
    }

    private func imageForFavoriteButton() -> UIImage {
        return character.isFavorite ?? false ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart")
    }
}
