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
    var favorites: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        favorites = [.init(name: "MS White Mdjskh", occupation: ["MS White Mdjskh"], img: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg", status: "eferer", nickname: "erferferf", appearance:[1], portrayed: "erferferfer")]
        configureTableView()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
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
        let destVC = CharacterInfoVC(name: favorite.name)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
