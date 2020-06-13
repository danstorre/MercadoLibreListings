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
    var presenterProductList: ListOfProductsPrensenter!
    var searchBroadCaster: BroadcastSearcherTermDelegateMessages!
    
    typealias ScreenViewControllerSearchAListOfDataProducts = UIViewController & ListsOfViewDataProducts & SearcherTermDelegate
    
    typealias MercadoLibreSearcher = SearcherTerm<ProductHolder<MercadoLibreListingProduct>,SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser>>
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            
        productListHolder = createAMercadoLibreListingProductHolder()
        
        let searcherNetworkService = createATermSearcherMercadoLibreNeworkService()
        //TODO:- Assign searcherNetworkService delegate
        
        let searcherService: MercadoLibreSearcher = createASearcherObject(with: searcherNetworkService,
                                                                          and: productListHolder!) as! SceneDelegate.MercadoLibreSearcher
        
        searchResultsUpdatingDelegate = createASearchBarUpdatingDelegate(with: searcherService)
        
        let searchController = createASearchcontroller(with: searchResultsUpdatingDelegate!)
        
        let searchScreenNav = createASearchScreenNavigationControllerWith(with: searchController)
        
        //create a presenter
        let viewWithPresentableListOfProducts = (searchScreenNav as? UINavigationController)?.topViewController as? ScreenViewControllerSearchAListOfDataProducts
        presenterProductList = ListOfProductsPrensenter(with: productListHolder!,
                                     and: viewWithPresentableListOfProducts!)
        productListHolder!.observer = presenterProductList
        
        searchBroadCaster = BroadcastSearcherTermDelegateMessages()
        searchBroadCaster.recipients.append(viewWithPresentableListOfProducts!)
        searchBroadCaster.recipients.append(searcherNetworkService)
        
        searcherService.delegate = searchBroadCaster
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreenNav
        window?.makeKeyAndVisible()
    }
    
    func createASearchcontroller(with delegate: UISearchResultsUpdating) -> UISearchController {
        return SearchControllerFactory
        .searchController(for: .normalWith(text: nil, andDelegate: searchResultsUpdatingDelegate!))
    }
    
    func createASearchScreenNavigationControllerWith(with searchController: UISearchController) -> UIViewController? {
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

