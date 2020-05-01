//
//  CharactersVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController {
    
    enum Section { case main }
    
    var characters: [Character] = []
    var filteredCharacters: [Character] = []
    var isFavourite = false
    var isSearching = false
    
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    var dataSource: CustomDataSource<Section, Character>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureTableView()
        configureActivityIndicator()
        getAllCharacters()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        backRowToNormalState()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "All BB Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureActivityIndicator() {
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a character name"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func backRowToNormalState() {
        tableView.setEditing(false, animated: true)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: false)
        }
    }
    
    func addFavoriteStatus(to characters : [Character]) -> [Character] {
        var favCharacters: [Character] = []
        for var character in characters {
            character.isFavorite = false
            favCharacters.append(character)
        }
        return favCharacters
    }
    
    func getAllCharacters() {
        NetworkManager.shared.getCharacters() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case.success(let characters):
                self.characters = characters
                self.characters = self.addFavoriteStatus(to: self.characters)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                    self.activityIndicator.stopAnimating()
                }
                self.updateData(on: characters)
            case .failure(let error):
                self.presentAlert(title: AlertTitle.error, message: "\(error.localizedDescription)", buttonTitle: "ОК")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = CustomDataSource<Section, Character>(tableView: tableView, cellProvider: { (tableView, indexPath, character) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID, for: indexPath) as! BBCell
            cell.set(character: character)
            return cell
        })
    }
    
    func updateData(on characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

extension CharactersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        let character = characters[indexPath.row]

        cell.set(character: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredCharacters : characters
        let character = activeArray[indexPath.row]
        let destVC = CharacterInfoVC(name: character.name.replacingOccurrences(of: " ", with: "+"))
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var character = characters[indexPath.row]

        character.isFavorite = PersistenceManager.shared.loadFavourite(for: character.nickname)

        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, _, completition) in
            character.isFavorite?.toggle()
            self.characters[indexPath.row].isFavorite?.toggle()
            PersistenceManager.shared.updateFavorites(with: character, isFavorite: character.isFavorite!)
            self.presentAlert(
                title: "\(character.name)",
                message: character.isFavorite! ? "♥︎" : "♡",
                buttonTitle: "ОК"
            )
            completition(true)
        }
        
        action.image = character.isFavorite! ? Images.heartIcon : Images.unselectedHeart
        action.backgroundColor = .systemBackground
        return action
    }
}

extension CharactersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredCharacters.removeAll()
            updateData(on: characters)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredCharacters = characters.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredCharacters)
    }
}
