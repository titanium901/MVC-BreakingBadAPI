//
//  FavoritesVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
        return tableView
    }()
    
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
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard !FavoriteList.shared.favorites.isEmpty else {
            showEmptyStateView(with: EmptyScreen.empty, in: view)
            return
        }
        
        layoutScreenIfHaveFavorite()
        if let index = tableView.indexPathForSelectedRow { tableView.deselectRow(at: index, animated: true) }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutScreenIfHaveFavorite() {
        tableView.reloadData()
        view.bringSubviewToFront(tableView)
        view.bringSubviewToFront(view)
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteList.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        let favorite = FavoriteList.shared.favorites[indexPath.row]
        cell.set(character: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = FavoriteList.shared.favorites[indexPath.row]
        
        let destVC = CharacterInfoVC(character: favorite)
        // передавай в конструктор
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let character = favoriteList.favorites[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, _, completition) in
//            character.isFavorite?.toggle()
            self.favoriteList.remove(character: character)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if FavoriteList.shared.favorites.isEmpty { self.showEmptyStateView(with: EmptyScreen.empty, in: self.view) }
            
//            character.updateFavoriteStatusInDB()
            self.presentAlert(
                title: AlertTitle.bye,
                message: "\(character.name) 💩",
                buttonTitle: "ОК"
            )
            completition(true)
        }
        
//        action.image = character.isFavorite! ? Images.heartIcon : Images.unselectedHeart
        action.backgroundColor = .systemBackground
        return action
    }
}
