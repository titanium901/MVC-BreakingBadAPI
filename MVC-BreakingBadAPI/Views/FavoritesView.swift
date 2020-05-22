//
//  FavoritesView.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class FavoritesView: UIView {
    
    lazy var tableView = update(UITableView()) {
        $0.frame = self.bounds
        $0.rowHeight = 200
        $0.removeExcessCells()
        $0.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupLayout() {
        addSubview(tableView, constraints: .allAnchors)
    }
}
