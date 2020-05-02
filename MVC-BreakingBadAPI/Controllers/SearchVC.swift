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

    // метод на самом деле не только создает но и устаналивает
    // нейминг не отражает этого
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushCharacterInfoVC() {
        characterTextField.resignFirstResponder()
        // валидацию можно вынести
        guard let name = characterTextField.text, !name.isEmpty else {
            presentAlert(title: AlertTitle.oops, message: AlertMessage.withoutName, buttonTitle: "ОК")
            return
        }
        
        let characterInfoVC = CharacterInfoVC(name: makeStringForInfoVC(for: name))
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
        characterTextField.delegate = self
        
        NSLayoutConstraint.activate([
            characterTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            characterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            characterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            characterTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // не забывай про инкапсуляцию
    // это все приватное
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

    func makeStringForInfoVC(for name: String) -> String {
        return name.trimmingCharacters(in:
            .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "+")
            .lowercased()
            .capitalized
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushCharacterInfoVC()
        return true
    }
}
