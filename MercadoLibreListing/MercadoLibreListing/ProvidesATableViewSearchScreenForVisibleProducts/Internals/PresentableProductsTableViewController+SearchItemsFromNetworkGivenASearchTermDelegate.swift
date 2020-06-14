//
//  PresentableProductList+SearchItemsFromNetworkGivenASearchTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension PresentableProductsTableViewController: SearcherTermDelegate {
    func willSearch() {
        (tableView.backgroundView as? EmptyMessage)?.toggle(on: false)
    }
    
    func didFinish(with searchError: SearcherTermError) {
        if case .serviceReturnNilItems(let searchedTermNotFound) = searchError {
            let emptyMessage = "No results found on search term: " + searchedTermNotFound
            let emptyImage = UIImage(systemName: "exclamationmark.bubble")!
            showMessage(emptyMessage, with: emptyImage)
        }
        (tableView.backgroundView as? EmptyMessage)?.toggle(on: true)
        arrayOfViewDataProducts.removeAll()
        tableView.reloadData()
    }
    
    func didFinish() {
        
    }
    
    fileprivate func showMessage(_ message: String, with image: UIImage) {
        (tableView.backgroundView as? EmptyMessage)?
            .setMessage(with: message,
                        and: image)
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
