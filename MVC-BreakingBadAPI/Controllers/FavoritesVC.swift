//
//  FavoritesVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    
    private var favoritesView: FavoritesView {
        view as! FavoritesView
    }
    
    override func loadView() {
        view = FavoritesView()
    }
    
    private let favoriteList: FavoriteList
    
    init(favoriteList: FavoriteList = .shared) {
        self.favoriteList = favoriteList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard !favoriteList.favorites.isEmpty else {
            showEmptyStateView(with: EmptyScreen.empty, in: view)
            return
        }
        
        layoutScreenIfHaveFavorite()
        // что то странное
        if let index = favoritesView.tableView.indexPathForSelectedRow { favoritesView.tableView.deselectRow(at: index, animated: true) }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutScreenIfHaveFavorite() {
        favoritesView.tableView.reloadData()
        view.bringSubviewToFront(favoritesView.tableView)
        view.bringSubviewToFront(view)
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        let favorite = favoriteList.favorites[indexPath.row]
        cell.set(character: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favoriteList.favorites[indexPath.row]
    
        let destVC = CharacterInfoVC(character: favorite)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let character = favoriteList.favorites[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, _, completition) in
            self.favoriteList.remove(character: character)
            self.favoritesView.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.favoriteList.favorites.isEmpty { self.showEmptyStateView(with: EmptyScreen.empty, in: self.view) }
            
            self.presentAlert(
                title: AlertTitle.bye,
                message: "\(character.name) 💩",
                buttonTitle: "ОК"
            )
            completition(true)
        }
        
        action.image = Images.heartIcon
        action.backgroundColor = .systemBackground
        return action
    }
}
