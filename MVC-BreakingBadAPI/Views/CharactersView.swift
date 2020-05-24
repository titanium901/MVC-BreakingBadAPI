//
//  CharactersView.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharactersView: UIView {
    
    lazy var tableView = update(UITableView()) {
        $0.frame = self.bounds // WTF?
        $0.rowHeight = 200
        $0.removeExcessCells()
        $0.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
    }
    lazy var activityIndicator = update(UIActivityIndicatorView()) {
        $0.startAnimating()
        $0.style = .large
        $0.color = .systemOrange
    }
    lazy var searchController = update(UISearchController()) {
        $0.searchBar.placeholder = "Search for a character name"
        $0.obscuresBackgroundDuringPresentation = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupLayout() {
        
        addSubview(tableView, constraints: [
            equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(\.leadingAnchor, constant: 0),
            equal(\.trailingAnchor, constant: 0),
            equal(\.bottomAnchor)
        ])
        
        addSubview(activityIndicator, constraints: [
            equal(\.centerXAnchor),
            equal(\.centerYAnchor)
        ])
    }
}
