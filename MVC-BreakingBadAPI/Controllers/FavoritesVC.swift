//
//  FavoritesVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 20.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    
    let tableView = UITableView()
    // Можно сделать модель Favorites/FaivoriteList
    // которая будет уметь загружать список избранных
    // добавлять в него
    // удалять из него
    var favorites: [Character] = []
    var favoritesCharacter: FavoritesCharacter

    init(favoritesCharacter: FavoritesCharacter) {
        self.favoritesCharacter = favoritesCharacter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // разбить на методы
        let favorites = favoritesCharacter.favorites
        if favorites.isEmpty {
            self.tableView.reloadDataOnMainThread()
            showEmptyStateView(with: EmptyScreen.empty, in: view)
        } else {
            // Зачем?
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
                self.view.bringSubviewToFront(self.view)
            }
        }
        // лучше не использовать self там где он не обязателен
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells() // сложно догадаться о чем речь
        tableView.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        let favorite = favorites[indexPath.row]
        cell.set(character: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = CharacterInfoVC(userNameInput: favorite.name.replacingOccurrences(of: " ", with: "+"))
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        var character = favorites[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, _, completition) in
            // Можно выносить в модель

            if favoritesCharacter.remove(character: character) {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }


//            character.isFavorite?.toggle()
//            self.favorites[indexPath.row].isFavorite?.toggle()
//            self.favorites.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            if self.favorites.isEmpty {
//                self.showEmptyStateView(with: EmptyScreen.empty, in: self.view)
//            }
//
//            PersistenceManager.shared.updateFavorites(with: character, isFavorite: character.isFavorite!)
            self.presentAlert(
                title: AlertTitle.bye,
                message: "\(character.name) 💩",
                buttonTitle: "ОК"
            )
            completition(true)
        }
        
        action.image = character.isFavorite! ? Images.heartIcon : Images.unselectedHeart
        action.backgroundColor = .systemBackground
        return action
    }
}
