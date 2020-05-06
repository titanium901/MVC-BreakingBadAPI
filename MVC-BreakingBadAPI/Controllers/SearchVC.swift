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
    
    var characters: [Character]? {
        didSet {
            searchCharacterButton.isHidden = false
            showAllCharacteButton.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoImageView()
        configureTextField()
        configureShowAllCharacteButton()
        configureSearchCharacterButton()
        configureLauoutUI()
        createAndSetDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        characterTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func createAndSetDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushCharacterInfoVC() {
        characterTextField.resignFirstResponder()
        guard characterTextField.checkTextIsNotEmpty() else {
            presentAlert(title: AlertTitle.oops, message: AlertMessage.withoutName, buttonTitle: "ОК")
            return
        }
        let characterInfoVC = CharacterInfoVC(userNameInput: makeStringForInfoVC(for: characterTextField.text!))
        if let characters = characters?.filter({ $0.name == characterTextField.text! }), !characters.isEmpty {
            characterInfoVC.character = characters.first
        }

        navigationController?.pushViewController(characterInfoVC, animated: true)
    }
    
    @objc func pushCharactersListVC() {
        characterTextField.resignFirstResponder()
        
        let charactersListVC = CharactersVC()
        guard let characters = characters else { return }
        charactersListVC.characters = characters
        navigationController?.pushViewController(charactersListVC, animated: true)
    }
    
    private func configureLogoImageView() {
        logoImageView.image = Images.bbLogo
    }
    
    private func configureTextField() {
        characterTextField.placeholder = "Enter a Character Name"
        characterTextField.delegate = self
    }
    
    private func configureShowAllCharacteButton() {
        showAllCharacteButton.isHidden = true
        showAllCharacteButton.addTarget(self, action: #selector(pushCharactersListVC), for: .touchUpInside)
    }
    
    private func configureSearchCharacterButton() {
        searchCharacterButton.isHidden = true
        searchCharacterButton.addTarget(self, action: #selector(pushCharacterInfoVC), for: .touchUpInside)
    }
    
    private func configureLauoutUI() {
        view.addSubviews(logoImageView, characterTextField, showAllCharacteButton, searchCharacterButton)
        showAllCharacteButton.translatesAutoresizingMaskIntoConstraints = false
        searchCharacterButton.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        characterTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoImageView.heightAnchor.constraint(equalToConstant: 400),
            
            characterTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            characterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            characterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            characterTextField.heightAnchor.constraint(equalToConstant: 50),
            
            showAllCharacteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            showAllCharacteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            showAllCharacteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            showAllCharacteButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchCharacterButton.bottomAnchor.constraint(equalTo: showAllCharacteButton.topAnchor, constant: -20),
            searchCharacterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchCharacterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchCharacterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func makeStringForInfoVC(for name: String) -> String {
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

extension SearchVC: NetworkManagerDelegate {
    func catchError(erorr: Error) {
        presentAlert(title: AlertTitle.error, message: erorr.localizedDescription, buttonTitle: "OK")
    }
}
