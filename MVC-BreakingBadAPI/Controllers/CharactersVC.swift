//
//  CharactersVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController {
    
    var characters: [Character] = []
    
    var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureActivityIndicator()
//        characters = [.init(name: "MS White Mdjskh", occupation: ["MS White Mdjskh"], img: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg", status: "eferer", nickname: "erferferf", appearance:[1], portrayed: "erferferfer")]
        getAllCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            activityIndicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor)
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
    
    func getAllCharacters() {
        NetworkManager.shared.getCharacters() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case.success(let characters):
                self.characters = characters
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                    self.activityIndicator.stopAnimating()
                }
                print(characters)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CharactersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        let character = characters[indexPath.row]

        cell.set(character: character)
        return cell
    }
}
