//
//  CustomDataSource.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 01.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CustomDataSource<SectionType: Hashable, ItemType: Hashable>: UITableViewDiffableDataSource<SectionType, ItemType> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
