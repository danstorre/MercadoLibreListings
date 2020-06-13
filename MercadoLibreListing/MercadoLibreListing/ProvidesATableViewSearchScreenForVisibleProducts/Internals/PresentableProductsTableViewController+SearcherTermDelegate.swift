//
//  PresentableProductsTableViewController+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension PresentableProductsTableViewController: SearcherTermDelegate{
    func willSearch() {
        toggleLoading(isHidden: false)
    }
    
    func didFinish(with: SearcherTermError) {
        toggleLoading(isHidden: true)
        let message = "no values returned from service"
        let title = "Search error."
        presentAlert(with: title, and: message)
    }
    
    func didFinish() {
        toggleLoading(isHidden: true)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func toggleLoading(isHidden: Bool) {
        tableView.tableHeaderView?.isHidden = isHidden
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    func presentAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
