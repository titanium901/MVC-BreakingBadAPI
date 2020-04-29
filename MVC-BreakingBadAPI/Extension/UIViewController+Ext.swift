//
//  UIViewController+Ext.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 29.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = BBEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
