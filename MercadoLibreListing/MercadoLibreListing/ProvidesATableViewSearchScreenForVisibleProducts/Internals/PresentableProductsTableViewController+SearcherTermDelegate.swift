//
//  PresentableProductsTableViewController+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension PresentableProductsTableViewController: SearchingTrafficDelegate{
    func didStartSearching() {
        toggleLoading(isHidden: false)
    }
    
    func didFinishSearching() {
        toggleLoading(isHidden: true)
    }
}
