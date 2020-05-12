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

    let favoritiesVC = FavoritesVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemOrange
        viewControllers = [createSearchNC(), createFavoritesNC()]

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
        favoritiesVC.title = "Favorities"
        favoritiesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        setFavoritesBadgeValue()
        
        return UINavigationController(rootViewController: favoritiesVC)
    }
    
    @objc func updateBadge(notification: NSNotification) {
        setFavoritesBadgeValue()
    }
    
    private func setFavoritesBadgeValue() {
        favoritiesVC.tabBarItem.badgeValue = FavoriteList.favorites.count == 0 ? nil : "\(FavoriteList.favorites.count)"
    }
}
