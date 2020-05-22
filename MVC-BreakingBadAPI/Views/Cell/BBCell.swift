//
//  BBCell.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 22.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit
import SDWebImage

class BBCell: UITableViewCell {
    
    static let reuseID = "BBCell"
    
    private let characterImageView = update(UIImageView()) {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemBackground
        $0.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
    }
    private let characterName = update(UILabel()) {
        $0.applyBBStyleForBBCell()
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    private let characterNickname = update(UILabel()) {
        $0.applyBBStyleForBBCell()
        $0.textColor = .orange
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    private let characterStatus = update(UILabel()) {
        $0.applyBBStyleForBBCell()
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    private let characterPortrayed = update(UILabel()) {
        $0.applyBBStyleForBBCell()
        $0.textColor = .orange
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: UIImage(named: "placeholder"))
    }
    
    private func _setupLayout() {
        
        let heightAnchor: CGFloat = 40
        let trailingAnchor: CGFloat = -20
        let leadingAnchor: CGFloat = 24
        let topAnchor: CGFloat = 40
        
        addSubview(characterImageView, constraints: [
            equal(\.centerYAnchor),
            equal(\.leadingAnchor, constant: 20),
            equal(\.heightAnchor, constant: 150),
            equal(\.widthAnchor, constant: 150)
        ])
        
        addSubview(characterName, constraints: [
            equal(\.topAnchor, constant: 15),
            equal(\.leadingAnchor, to: characterImageView, \.trailingAnchor, constant: leadingAnchor),
            equal(\.trailingAnchor, constant: trailingAnchor),
            equal(\.heightAnchor, constant: heightAnchor)
        ])
        
        addSubview(characterNickname, constraints: [
            equal(\.topAnchor, to: characterName, \.topAnchor, constant: topAnchor),
            equal(\.leadingAnchor, to: characterImageView, \.trailingAnchor, constant: leadingAnchor),
            equal(\.trailingAnchor, constant: trailingAnchor),
            equal(\.heightAnchor, constant: heightAnchor)
        ])
        
        addSubview(characterStatus, constraints: [
            equal(\.topAnchor, to: characterNickname, \.topAnchor, constant: topAnchor),
            equal(\.leadingAnchor, to: characterImageView, \.trailingAnchor, constant: leadingAnchor),
            equal(\.trailingAnchor, constant: trailingAnchor),
            equal(\.heightAnchor, constant: heightAnchor)
        ])
        
        addSubview(characterPortrayed, constraints: [
            equal(\.topAnchor, to: characterStatus, \.topAnchor, constant: topAnchor),
            equal(\.leadingAnchor, to: characterImageView, \.trailingAnchor, constant: leadingAnchor),
            equal(\.trailingAnchor, constant: trailingAnchor),
            equal(\.heightAnchor, constant: heightAnchor)
        ])
  
    }
}
