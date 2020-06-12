//
//  PresentableProductsTableViewController+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension PresentableProductsTableViewController: SearcherTermDelegate{
    func willSearch() {
        //add loading.
    }
    
    func didFinish(with: SearcherTermError) {
        //present an alert
    }
    
    func didFinish() {
        //remove loading.
        //remove any alerts.
    }
}
