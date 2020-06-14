//
//  PresentableProductsTableViewController+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension PresentableProductsTableViewController: SearchingTrafficDelegate{
    func didFinishSearching(with errorToDisplay: NetworkSearchingTrafficDelegateError) {
        switch errorToDisplay {
            case .appError:
                let appErrorMessage = "There was something wrong with the app, please try another search term."
                let emptyImage = UIImage(systemName: "exclamationmark.bubble")!
                setMessage(appErrorMessage, with: emptyImage)
            
            case .noconnectivityError:
                let noconnectivityErrorMessage = "Please check your internet connection first"
                let emptyImage = UIImage(systemName: "exclamationmark.bubble")!
                setMessage(noconnectivityErrorMessage, with: emptyImage)
            
            case .searchNotFound(with: let searchedTermNotFound):
                let emptyMessage = "No results found on search term: " + searchedTermNotFound
                let emptyImage = UIImage(systemName: "exclamationmark.bubble")!
                setMessage(emptyMessage, with: emptyImage)
            
            case .serverError:
                let serverErrorMessage = "There is something wrong with the servers, please try again later."
                let emptyImage = UIImage(systemName: "exclamationmark.bubble")!
                setMessage(serverErrorMessage, with: emptyImage)
        }
            
        (tableView.backgroundView as? EmptyMessage)?.toggle(on: true)
        arrayOfViewDataProducts.removeAll()
        tableView.reloadData()
        toggleLoading(isHidden: true)
    }
    
    func didStartSearching() {
        (tableView.backgroundView as? EmptyMessage)?.toggle(on: false)
        toggleLoading(isHidden: false)
    }
    
    func didFinishSearching() {
        (tableView.backgroundView as? EmptyMessage)?.toggle(on: false)
        toggleLoading(isHidden: true)
    }

    fileprivate func setMessage(_ message: String, with image: UIImage) {
        (tableView.backgroundView as? EmptyMessage)?
            .setMessage(with: message,
                        and: image)
    }
}
