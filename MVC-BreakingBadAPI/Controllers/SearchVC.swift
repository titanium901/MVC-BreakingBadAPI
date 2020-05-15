//
//  SearchVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    private let logoImageView = update(UIImageView()) {
        $0.image = Images.bbLogo
    }
    private lazy var characterTextField = update(UITextField()) {
        $0.applyBBStyle()
        $0.placeholder = "Enter a Character Name"
        $0.delegate = self
    }
    private let searchCharacterButton = update(UIButton()) {
        $0.applyBBStyle()
        $0.setTitle("Search", for: .normal)
        $0.backgroundColor = .orange
        $0.addTarget(self, action: #selector(pushCharacterInfoVC), for: .touchUpInside)
    }
    private let showAllCharacteButton = update(UIButton()){
        $0.applyBBStyle()
        $0.setTitle("Show All Characters", for: .normal)
        $0.backgroundColor = .black
        $0.addTarget(self, action: #selector(pushCharactersListVC), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
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
    
    @objc private func pushCharacterInfoVC() {
        guard let text = characterTextField.text else { return }
        var textChecker = TextChecker(text: text)
        textChecker.checkUserInput()
        if !textChecker.isValid {
            presentAlert(title: AlertTitle.oops, message: AlertMessage.withoutName, buttonTitle: "ОК")
            return
        }
        
        let characterInfoVC = CharacterInfoVC(
            searchRequest: SearchRequest(
                characterName: textChecker.searchValidText
            )
        )
        navigationController?.pushViewController(characterInfoVC, animated: true)
    }
    
    @objc private func pushCharactersListVC() {
        let charactersListVC = CharactersVC()
        navigationController?.pushViewController(charactersListVC, animated: true)
    }
    
    private func layoutUI() {
        view.addSubviews(logoImageView, characterTextField, showAllCharacteButton, searchCharacterButton)
        
        [logoImageView,
         characterTextField,
         showAllCharacteButton,
         searchCharacterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushCharacterInfoVC()
        characterTextField.resignFirstResponder()
        return true
    }
}
