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
    var name: String!
    var isFavourite = false
    
    init(name: String) {
        super.init(nibName: nil, bundle: nil)
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStackView()
        configureActivityIndicator()
        lauoutUI()
        configureaddToFavoriteButton()
        getCharacterInfo()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getCharacterInfo() {
        NetworkManager.shared.getCharacter(name: name) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let character):
                self.character = character.first!
                DispatchQueue.main.async { self.configureUIElements(with: self.character) }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureUIElements(with character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterAppearance.text = "\(character.appearance)"
        
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: UIImage(named: "placeholder"))
        
        loadFavouriteStatus()
        addToFavoriteButton.setImage(setImageForFavoriteButton(), for: .normal)
        addToFavoriteButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(characterName)
        stackView.addArrangedSubview(characterNickname)
        stackView.addArrangedSubview(characterStatus)
        stackView.addArrangedSubview(characterPortrayed)
        stackView.addArrangedSubview(characterAppearance)
    }
    
    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureaddToFavoriteButton() {
        addToFavoriteButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        addToFavoriteButton.isEnabled = false
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func lauoutUI() {
        view.addSubviews(characterImageView, stackView, addToFavoriteButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    @objc func addButtonTapped() {
        isFavourite.toggle()
        let image = setImageForFavoriteButton()
        addToFavoriteButton.setImage(image, for: .normal)
        PersistenceManager.shared.updateFavorites(with: character, isFavorite: isFavourite)
    }
    
    private func setImageForFavoriteButton() -> UIImage {
        return isFavourite ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart")
    }
    
    private func loadFavouriteStatus() {
        isFavourite = PersistenceManager.shared.loadFavourite(for: String(character.nickname))
    }
}
