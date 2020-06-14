//
//  PresentableProductList+SearchItemsFromNetworkGivenASearchTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension PresentableProductsTableViewController: SearcherTermDelegate {
    func willSearch() {
        (tableView.backgroundView as? EmptyMessage)?.isHidden = true
    }
    
    func didFinish(with searchError: SearcherTermError) {
        
        if case .serviceReturnNilItems(let searchedTermNotFound) = searchError {
            let emptyMessage = "No results found with: " + searchedTermNotFound
            (tableView.backgroundView as? EmptyMessage)?.setMessage(with: emptyMessage )
        }
        (tableView.backgroundView as? EmptyMessage)?.isHidden = false
        arrayOfViewDataProducts.removeAll()
        tableView.reloadData()
    }
    
    func didFinish() {
        
    }
}

extension PresentableProductsTableViewController: SearchItemsFromNetworkGivenASearchTermDelegate {
    func didFinishAllCurrentTasks() {
    }
    
    func errorWhenCreatingURL(_: Error) {
    }
    
    func errorWhenMakingANetworkRequest(_: Error) {
    }
}
