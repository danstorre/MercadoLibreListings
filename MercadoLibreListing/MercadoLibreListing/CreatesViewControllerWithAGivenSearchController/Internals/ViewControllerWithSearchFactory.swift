//
//  ViewControllerWithSearchFactory.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum ViewControllerWithSearchFactory {
    static func viewController(for option: ViewControllerWithSearchBarFactoryOptions) -> UIViewController {
        switch option {
        case .viewcontroller(let searchController):
            return SearchViewControllerMaker(searchController: searchController)
                .makeViewController()
        }
    }
}

fileprivate protocol ViewControllerMaker {
    func makeViewController() -> UIViewController
}

fileprivate struct SearchViewControllerMaker: ViewControllerMaker {
    let searchController: UISearchController

    func makeViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        guard let nav = storyBoard.instantiateInitialViewController() as? UINavigationController,
            let vc = nav.topViewController as? SearchBarEmbededViewController else {
                return UIViewController()
        }
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.hidesSearchBarWhenScrolling = false
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.navigationItem.title = "Discover"
        vc.navigationItem.searchController = searchController
        vc.definesPresentationContext = true
        return nav
    }
}


