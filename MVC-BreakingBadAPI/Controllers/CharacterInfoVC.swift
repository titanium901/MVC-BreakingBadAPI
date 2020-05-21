//
//  CharacterInfoVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharacterInfoVC: UIViewController {
    
    private let searchRequest: SearchRequest?
    private let favoriteList: FavoriteList
    private var character: Character! {
        didSet {
            characterInfoView.configureUIElements(with: character, favoriteList: favoriteList)
        }
    }

    private var characterInfoView: CharacterInfoView {
        view as! CharacterInfoView
    }
    
    init(searchRequest: SearchRequest? = nil, favoriteList: FavoriteList = .shared) {
        self.searchRequest = searchRequest
        self.favoriteList = favoriteList
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(character: Character) {
        self.init(searchRequest: nil)
        self.character = character
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CharacterInfoView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        characterInfoView.addToFavoriteButton.addTarget(self, action: #selector(self.addDeleteFavoriteButtonTapped), for: .touchUpInside)
        guard searchRequest != nil else {
            characterInfoView.configureUIElements(with: character, favoriteList: favoriteList)
            return
        }
        loadCharacter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadCharacter() {
        Character.loadCharacter(by: searchRequest!.query) { [weak self] char, error  in
            guard let self = self else { return }
            guard error == nil else {
                self.showNetworkErrorAlert(error: error!)
                return
            }
            guard let char = char else {
                self.characterNotFound(
                    message: self.searchRequest?.characterName ?? ""
                )
                return
            }
            self.character = char
        }
    }
    
    @objc private func addDeleteFavoriteButtonTapped() {
        favoriteList.isFavorite(character: character) ? favoriteList.remove(character: character) : favoriteList.add(character: character)
        let image = favoriteList.isFavorite(character: character) ? #imageLiteral(resourceName: "heartIcon") : #imageLiteral(resourceName: "unselectedHeart")
        characterInfoView.addToFavoriteButton.setImage(image, for: .normal)
    }
    
    private func characterNotFound(message: String) {
        presentAlert(
            title: AlertTitle.error,
            message: message + " - not found",
            buttonTitle: "ОК"
        )
        
        characterInfoView.activityIndicator.stopAnimating()
        characterInfoView.characterImageView.isHidden = true
        showEmptyStateView(with: "Empty", in: view)
    }
    
    private func showNetworkErrorAlert(error: Error) {
        presentAlert(title: AlertTitle.oops, message: error.localizedDescription, buttonTitle: "ОК")
        showEmptyStateView(with: error.localizedDescription, in: view)
        characterInfoView.activityIndicator.stopAnimating()
    }
}
