//
//  SearchControllerFactory.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit


enum SearchControllerFactory {
    static func searchController(for option: SearchControllerFactoryOptions) -> UISearchController {
        switch option {
        case .normal(let text):
            return NormalSearchControlerMaker(text: text ?? "").makeSearchControler()
        }
    }
}

fileprivate protocol SearchControlerMaker {
    func makeSearchControler() -> UISearchController
}

struct NormalSearchControlerMaker: SearchControlerMaker {
    let text: String

    func makeSearchControler() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.navigationItem.largeTitleDisplayMode = .always
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.text = text
        searchController.showsSearchResultsController = true
        return searchController
    }
}
