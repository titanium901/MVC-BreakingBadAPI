//
//  BBAlertVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 29.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class BBAlertVC: UIViewController {
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .label)
        return label
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.applyBBStyle(textColor: .orange)
        label.numberOfLines = 4
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.applyBBStyle(title: "OK", backgroundColor: .orange)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()

    // Можно в модель запаковать
    // тогда три метода configure.. в один
    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?
    
    private let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
        configureLayoutUI()
    }
    
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
    }
    
    private func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
    }
    
    private func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
    }
    
    private func configureLayoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
