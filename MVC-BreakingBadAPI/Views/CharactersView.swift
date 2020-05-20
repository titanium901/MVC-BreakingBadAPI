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
        $0.backgroundColor = .systemBackground
        $0.frame = self.bounds
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
        addSubviews()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(tableView)
        tableView.addSubview(activityIndicator)
    }
    
    private func layoutUI() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
