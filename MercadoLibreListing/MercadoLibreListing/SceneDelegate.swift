//
//  SceneDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var productListHolder: ProductHolder<MercadoLibreListingProduct>?
    var searchResultsUpdatingDelegate: UISearchResultsUpdating?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        productListHolder = createAMercadoLibreListingProductHolder()
    
        let searcherNetworkService = createATermSearcherMercadoLibreNeworkService()
        //TODO:- Assign searcherNetworkService delegate
        
        let searcherService = createASearcherObject(with: searcherNetworkService, and: productListHolder!)
        //TODO:- Assign searcherService delegate
        
        searchResultsUpdatingDelegate = createASearchBarUpdatingDelegate(with: searcherService)
        
        let searchController = createASearchcontroller(with: searchResultsUpdatingDelegate!)
        
        let searchScreen = createASearchScreenWith(with: searchController)
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreen
        window?.makeKeyAndVisible()
    }
    
    func createASearchcontroller(with delegate: UISearchResultsUpdating) -> UISearchController {
        return SearchControllerFactory
        .searchController(for: .normalWith(text: nil, andDelegate: searchResultsUpdatingDelegate!))
    }
    
    func createASearchScreenWith(with searchController: UISearchController) -> UIViewController {
        return ViewControllerWithSearchFactory
        .viewController(for:
            .viewcontroller(withSearchController: searchController))
    }
    
    func createASearchBarUpdatingDelegate(with searcherService: SearcherProtocol) -> UISearchResultsUpdating {
        return SearchBarResultsUpdating(searcher: searcherService)
    }
    
    func createASearcherObject<T: ItemSearcherService, E: ItemHolder>
        (with service: T, and repo: E) -> SearcherProtocol where E.T == T.T{

        return SearcherTerm(repository: repo, service: service)
    }
    
    func createATermSearcherMercadoLibreNeworkService() -> SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser> {
        let searcherNetworkService = SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser>(urlMaker: MercadoLibreURLFactory())
        searcherNetworkService.parser = MercadolibreGetParser()
        return searcherNetworkService
    }
    
    func createAMercadoLibreListingProductHolder() -> ProductHolder<MercadoLibreListingProduct>{
        return ProductHolder(products: [MercadoLibreListingProduct]())
    }
    
}

