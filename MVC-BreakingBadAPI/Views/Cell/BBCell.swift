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
        layoutUI()
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
    
    private func layoutUI() {
        addSubviews(characterImageView, characterName, characterNickname, characterStatus, characterPortrayed)
        
        [characterImageView,
         characterName,
         characterNickname,
         characterStatus,
         characterPortrayed].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let heightAnchor: CGFloat = 40
        let trailingAnchor: CGFloat = -20
        let leadingAnchor: CGFloat = 24
        let topAnchor: CGFloat = 40
        
        NSLayoutConstraint.activate([
            characterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            characterName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            characterName.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterName.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterNickname.topAnchor.constraint(equalTo: characterName.topAnchor, constant: topAnchor),
            characterNickname.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterNickname.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterNickname.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterStatus.topAnchor.constraint(equalTo: characterNickname.topAnchor, constant: topAnchor),
            characterStatus.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterStatus.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterPortrayed.topAnchor.constraint(equalTo: characterStatus.topAnchor, constant: topAnchor),
            characterPortrayed.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterPortrayed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterPortrayed.heightAnchor.constraint(equalToConstant: heightAnchor)
        ])
    }
}
