//
//  PresentableProductsTableViewController+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol SearchingTrafficDelegate: class {
    func didStartSearching()
    func didFinishSearching()
}

typealias NetworkSearchingTraffic = SearcherTermDelegate & SearchItemsFromNetworkGivenASearchTermDelegate

class NetworkSearchingTrafficDelegate: NetworkSearchingTraffic {

    weak var delegate: SearchingTrafficDelegate?
    var keepSearching: Bool = false
    
    func willSearch() {
        guard !keepSearching else { return }
        keepSearching = true
        delegate?.didStartSearching()
    }
    
    func didFinish(with: SearcherTermError) {
        //log?
    }
    
    func didFinish() {
        //log?
    }
    
    func didFinishAllCurrentTasks() {
        keepSearching = false
        delegate?.didFinishSearching() 
    }
    
    func errorWhenCreatingURL(_: Error) {
        //log?
    }
    
    func errorWhenMakingANetworkRequest(_: Error) {
        //log?
    }
}

extension PresentableProductsTableViewController: SearchingTrafficDelegate{
    func didStartSearching() {
        toggleLoading(isHidden: false)
    }
    
    func didFinishSearching() {
        toggleLoading(isHidden: true)
    }
    
    func toggleLoading(isHidden: Bool) {
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        
        tableView?.tableHeaderView?.frame.size.height = isHidden ? 0 : 71
        
        header?.setNeedsLayout()
        header?.layoutIfNeeded()
        
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visibleIndexPaths, with: .none)
        }
    }
}
