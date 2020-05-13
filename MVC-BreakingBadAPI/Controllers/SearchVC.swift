//
//  SearchVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.bbLogo
        return imageView
    }()
    private lazy var characterTextField: UITextField = {
        let textField = UITextField()
        textField.applyBBStyle()
        textField.placeholder = "Enter a Character Name"
        textField.delegate = self
        return textField
    }()
    private lazy var searchCharacterButton: UIButton = {
        let button = UIButton()
        button.applyBBStyle(title: "Search", backgroundColor: .orange)
        button.addTarget(self, action: #selector(pushCharacterInfoVC), for: .touchUpInside)
        return button
    }()
    private lazy var showAllCharacteButton: UIButton = {
        let button = UIButton()
        button.applyBBStyle(title: "Show All Characters", backgroundColor: .black)
        button.addTarget(self, action: #selector(pushCharactersListVC), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutUI()
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
        characterTextField.resignFirstResponder()
        guard let text = characterTextField.text else { return }
        // очень подозрительное название переменной
        var input = TextChecker(text: text)
        input.checkUserInput()
        if !input.isValid {
            presentAlert(title: AlertTitle.oops, message: AlertMessage.withoutName, buttonTitle: "ОК")
            return
        }

        // эту строчку вообще не понял
        SearchValidRequest.shared.validName = input.searchValidText
        let characterInfoVC = CharacterInfoVC()
        navigationController?.pushViewController(characterInfoVC, animated: true)
    }
    
    @objc private func pushCharactersListVC() {
        // эту можно обернуть в метод так как не понятно зачем она вызывается
        // еще и дублируется
        characterTextField.resignFirstResponder()
        
        let charactersListVC = CharactersVC()
        navigationController?.pushViewController(charactersListVC, animated: true)
    }
    
    private func configureLayoutUI() {
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
