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
    
    typealias ScreenViewControllerSearchAListOfDataProducts = UIViewController & ListsOfViewDataProducts & SearcherTermDelegate
    
    typealias MercadoLibreSearcher = SearcherTerm<ProductHolder<MercadoLibreListingProduct>,SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser>>
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        productListHolder = createAMercadoLibreListingProductHolder()
        
        let searcherNetworkService = createATermSearcherMercadoLibreNeworkService()
        //TODO:- Assign searcherNetworkService delegate
        
        let searcherService: MercadoLibreSearcher = createASearcherObject(with: searcherNetworkService, and: productListHolder!) as! SceneDelegate.MercadoLibreSearcher
        
        searchResultsUpdatingDelegate = createASearchBarUpdatingDelegate(with: searcherService)
        
        let searchController = createASearchcontroller(with: searchResultsUpdatingDelegate!)
        
        let searchScreen = createASearchScreenWith(with: searchController)
        
        //create a presenter
        let viewWithPresentableListOfProducts = (searchScreen as? UINavigationController)?.topViewController as? ScreenViewControllerSearchAListOfDataProducts
        let productsPresenter = ListOfProductsPrensenter(with: productListHolder!,
                                     and: viewWithPresentableListOfProducts!)
        productListHolder!.observer = productsPresenter
        
        searcherService.delegate = viewWithPresentableListOfProducts
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreen
        window?.makeKeyAndVisible()
    }
    
    func createASearchcontroller(with delegate: UISearchResultsUpdating) -> UISearchController {
        return SearchControllerFactory
        .searchController(for: .normalWith(text: nil, andDelegate: searchResultsUpdatingDelegate!))
    }
    
    func createASearchScreenWith(with searchController: UISearchController) -> UIViewController? {
        return ViewControllerWithSearchFactory
        .viewController(for:
            .tableViewControllerForVisibleProducts(withSearchController: searchController))
    }
    
    func createASearchBarUpdatingDelegate(with searcherService: SearcherProtocol) -> UISearchResultsUpdating {
        return SearchBarResultsUpdating(searcher: searcherService)
    }
    
    func createASearcherObject<T: ItemSearcherService, E: ItemHolder>
        (with service: T, and repo: E, plus: SearcherTermDelegate? = nil) -> SearcherProtocol where E.T == T.T{
        let searchTerm = SearcherTerm(repository: repo, service: service)
        searchTerm.delegate = plus
        return searchTerm
    }
    
    func createATermSearcherMercadoLibreNeworkService(with delegate: SearchItemsFromNetworkGivenASearchTermDelegate? = nil) -> SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser> {
        let searcherNetworkService = SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser>(urlMaker: MercadoLibreURLFactory())
        searcherNetworkService.parser = MercadolibreGetParser()
        searcherNetworkService.delegate = delegate
        return searcherNetworkService
    }
    
    func createAMercadoLibreListingProductHolder() -> ProductHolder<MercadoLibreListingProduct>{
        return ProductHolder(products: [MercadoLibreListingProduct]())
    }
    
}

