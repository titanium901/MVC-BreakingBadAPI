//
//  BBAlertVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 29.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class BBAlertVC: UIViewController {
    
    private let containerView = update(UIView()) {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
    }
    private let titleLabel = update(UILabel()) {
        $0.applyBBStyle()
    }
    private let messageLabel = update(UILabel()) {
        $0.applyBBStyle()
        $0.textColor = .orange
        $0.numberOfLines = 4
    }
    private let actionButton = update(UIButton()) {
        $0.applyBBStyle()
        $0.setTitle("OK", for: .normal)
        $0.backgroundColor = .orange
        $0.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    private var alert: BBAlert?
    
    private let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alert = BBAlert(alertTitle: title, message: message, buttonTitle: buttonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureAlert()
        layoutUI()
    }
    
    private func configureAlert() {
        titleLabel.text = alert?.alertTitle ?? "Something went wrong"
        messageLabel.text = alert?.message ?? "Unable to complete request"
        actionButton.setTitle(alert?.buttonTitle ?? "OK", for: .normal)
    }
    
    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        
        [containerView,
         titleLabel,
         actionButton,
         messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
