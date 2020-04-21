//
//  SearchVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let characterTextView = BBTextField()
    let searchCharacterButton = BBButton(backgroundColor: .orange, title: "Search")
    let showAllCharacteButton = BBButton(backgroundColor: .black, title: "Show All Characters")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(logoImageView, characterTextView, showAllCharacteButton, searchCharacterButton)
        configureLogoImageView()
        configureTextField()
        configureShowAllCharacteButton()
        configureSearchCharacterButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushCharacterInfoVC() {
        characterTextView.resignFirstResponder()
        
        let characterInfoVC = CharacterInfoVC()
        navigationController?.pushViewController(characterInfoVC, animated: true)
    }
    
    @objc func pushCharactersListVC() {
        characterTextView.resignFirstResponder()
        
        let charactersListVC = CharactersVC()
        navigationController?.pushViewController(charactersListVC, animated: true)
    }
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.bbLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func configureTextField() {
        NSLayoutConstraint.activate([
            characterTextView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            characterTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            characterTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            characterTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureShowAllCharacteButton() {
        showAllCharacteButton.addTarget(self, action: #selector(pushCharactersListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showAllCharacteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            showAllCharacteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            showAllCharacteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            showAllCharacteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSearchCharacterButton() {
        searchCharacterButton.addTarget(self, action: #selector(pushCharacterInfoVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchCharacterButton.bottomAnchor.constraint(equalTo: showAllCharacteButton.topAnchor, constant: -20),
            searchCharacterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchCharacterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchCharacterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
