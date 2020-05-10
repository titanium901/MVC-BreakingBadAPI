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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.style = .large
        activity.color = .systemOrange
        return activity
    }()
    
    private var filteredCharacters: [Character] = []
    private var isSearching = false
    private var dataSource: CustomDataSource<Section, Character>!
    
    private var characters: [Character] = [] {
        didSet {
            characters = Character.addFavoriteStatusToAll(to: characters)
            
            tableView.reloadData()
            view.bringSubviewToFront(self.tableView)
            activityIndicator.stopAnimating()
            updateData(on: characters)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        layoutUI()
        configureDataSource()
        loadAllCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        backRowToNormalState()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "All BB Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a character name"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func loadAllCharacters() {
        Character.loadAllCharacters { characters in
            guard let characters = characters else {
                self.presentAlert(title: AlertTitle.oops, message: AlertMessage.somethingWrong, buttonTitle: "ОК")
                return
            }
            self.characters = characters
        }
    }
    
    private func configureDataSource() {
        dataSource = CustomDataSource<Section, Character>(tableView: tableView, cellProvider: { (tableView, indexPath, character) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID, for: indexPath) as! BBCell
            cell.set(character: character)
            return cell
        })
    }
    
    private func backRowToNormalState() {
        tableView.setEditing(false, animated: true)
        if let index = tableView.indexPathForSelectedRow { tableView.deselectRow(at: index, animated: false) }
    }
    
    private func updateData(on characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

extension CharactersVC: NetworkManagerDelegate {
    func dataReady(character: Character) {
    }

    func catchError(erorr: Error) {
        presentAlert(title: AlertTitle.error, message: erorr.localizedDescription, buttonTitle: "OK")
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
        let destVC = CharacterInfoVC()
        destVC.character = character
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var character = characters[indexPath.row]

        character.isFavorite = PersistenceManager.shared.loadFavouriteStatus(for: character.nickname)

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
