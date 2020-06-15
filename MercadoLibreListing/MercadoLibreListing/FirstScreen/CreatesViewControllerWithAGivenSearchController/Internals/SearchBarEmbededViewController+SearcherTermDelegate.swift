//
//  SearchBarEmbededViewController+Item.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension SearchBarEmbededViewController: SearcherTermDelegate{
    func willSearch() {
        
    }
    
    func didFinish(with: SearcherTermError) {
        //presents alert
    }
    
    func didFinish() {
        //prints finished.
    }
}
