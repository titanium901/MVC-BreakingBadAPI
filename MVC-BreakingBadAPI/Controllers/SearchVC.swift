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
    let characterTextField = BBTextField()
    let searchCharacterButton = BBButton(backgroundColor: .orange, title: "Search")
    let showAllCharacteButton = BBButton(backgroundColor: .black, title: "Show All Characters")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(logoImageView, characterTextField, showAllCharacteButton, searchCharacterButton)
        configureLogoImageView()
        configureTextField()
        configureShowAllCharacteButton()
        configureSearchCharacterButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        characterTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushCharacterInfoVC() {
        characterTextField.resignFirstResponder()
        guard let name = characterTextField.text, !name.isEmpty else {
            presentAlert(title: "Упс...", message: "Не знаю персонажей без имени(", buttonTitle: "ОК")
            return
        }
        let characterInfoVC = CharacterInfoVC(name: name.replacingOccurrences(of: " ", with: "+"))
        navigationController?.pushViewController(characterInfoVC, animated: true)
    }
    
    @objc func pushCharactersListVC() {
        characterTextField.resignFirstResponder()
        
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
            characterTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            characterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            characterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            characterTextField.heightAnchor.constraint(equalToConstant: 50)
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
