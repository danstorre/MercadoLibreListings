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
        //hide tableview if you will.
        //do some clean up maybe cancel all requests of the array view data?.
    }
    
    func didFinish(with: SearcherTermError) {
        //present an alert
    }
    
    func didFinish() {
        //show tableview if you will.
        //remove loading.
        //remove any alerts.
    }
}
