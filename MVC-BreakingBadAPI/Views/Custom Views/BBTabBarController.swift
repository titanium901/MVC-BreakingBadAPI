//
//  BBTabBarController.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class BBTabBarController: UITabBarController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    enum TabBarType: Int {
        case search
        case favorites
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNC(), createFavoritesNC()]
        
        setFavoritesBadgeValue()
        NotificationFavoriteBadge.addObserver(with: #selector(updateBadge), observer: self)
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.view.backgroundColor = .systemBackground
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesNC() -> UINavigationController {
        let favoritiesVC = FavoritesVC()
        favoritiesVC.title = "Favorities"
        favoritiesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritiesVC)
    }
    
    @objc func updateBadge(notification: NSNotification) {
        setFavoritesBadgeValue()
    }
    
    private func setFavoritesBadgeValue() {
        viewControllers?[TabBarType.favorites.rawValue].tabBarItem.badgeValue = FavoriteList.shared.favorites.count == 0 ? nil : "\(FavoriteList.shared.favorites.count)"
    }
}
