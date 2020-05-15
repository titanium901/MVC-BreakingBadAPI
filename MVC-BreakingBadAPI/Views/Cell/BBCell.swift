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
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        return imageView
    }()
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.applyBBStyleForBBCell()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    private lazy var characterNickname: UILabel = {
        let label = UILabel()
        label.applyBBStyleForBBCell()
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private lazy var characterStatus: UILabel = {
        let label = UILabel()
        label.applyBBStyleForBBCell()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    private lazy var characterPortrayed: UILabel = {
        let label = UILabel()
        label.applyBBStyleForBBCell()
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
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
