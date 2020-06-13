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
    }
    
    func didFinish() {
    }
    
    func toggleLoading(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.tableHeaderView?.bounds.size.height = isHidden ? 0 : 71
            self?.tableView.tableHeaderView?.setNeedsLayout()
            self?.tableView.tableHeaderView?.layoutIfNeeded()
            isHidden ? self?.activityIndicator.stopAnimating() : self?.activityIndicator.startAnimating()
        })
    }
}
