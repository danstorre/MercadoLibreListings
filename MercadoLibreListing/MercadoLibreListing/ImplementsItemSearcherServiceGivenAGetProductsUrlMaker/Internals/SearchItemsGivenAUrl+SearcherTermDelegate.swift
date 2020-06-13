//
//  SearchItemsGivenAUrl+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension SearchItemsFromNetworkGivenASearchTerm: SearcherTermDelegate {
    func willSearch() {
        for currentTask in currentTasks {
            currentTask.suspend()
            currentTask.cancel()
        }
    }
    
    func didFinish(with: SearcherTermError) {
        
    }
    
    func didFinish() {
        
    }
    
}
