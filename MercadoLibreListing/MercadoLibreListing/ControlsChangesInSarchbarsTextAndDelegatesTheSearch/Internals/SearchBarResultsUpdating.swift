//
//  SearchBarResultsUpdating.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class SearchBarResultsUpdating: NSObject, UISearchResultsUpdating {
    var searcher: SearcherProtocol
    
    init(searcher: SearcherProtocol) {
       self.searcher = searcher
       super.init()
   }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            fatalError()
        }
        if searchController.searchBar.text != "" {
            searcher.search(term: text)
        }
    }
}
