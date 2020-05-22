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
        _setupLayout()
    }
    
    private func configureAlert() {
        titleLabel.text = alert?.alertTitle ?? "Something went wrong"
        messageLabel.text = alert?.message ?? "Unable to complete request"
        actionButton.setTitle(alert?.buttonTitle ?? "OK", for: .normal)
    }
    
    private func _setupLayout() {
 
        containerView.addSubviews(titleLabel, actionButton)
 
        view.addSubview(containerView, constraints: [
            equal(\.centerYAnchor),
            equal(\.centerXAnchor),
            equal(\.widthAnchor, constant: 300),
            equal(\.heightAnchor, constant: 250)
        ])
        
        containerView.addSubview(messageLabel, constraints: [
            equal(\.topAnchor, to: titleLabel, \.bottomAnchor, constant: 8),
            equal(\.leadingAnchor, constant: padding),
            equal(\.trailingAnchor, constant: -padding),
            equal(\.bottomAnchor, to: actionButton, \.topAnchor, constant: -12)
        ])
        
        containerView.addSubview(titleLabel, constraints: [
            equal(\.topAnchor, constant: padding),
            equal(\.leadingAnchor, constant: padding),
            equal(\.trailingAnchor, constant: -padding),
            equal(\.heightAnchor, constant: 28)
        ])
        
        containerView.addSubview(actionButton, constraints: [
            equal(\.bottomAnchor, constant: -padding),
            equal(\.leadingAnchor, constant: padding),
            equal(\.trailingAnchor, constant: -padding),
            equal(\.heightAnchor, constant: 44)
        ])
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
