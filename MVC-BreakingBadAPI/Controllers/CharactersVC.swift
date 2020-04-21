//
//  CharactersVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        getAllCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getAllCharacters() {
        NetworkManager.shared.getCharacters(name: "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case.success(let characters):
                print(characters)
            case .failure(let error):
                print(error)
            }
        }
    }
}
