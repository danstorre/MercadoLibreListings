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
    var searcherNetworkTrafficController: NetworkSearchingTrafficDelegate?
    var throtleSearch: SearcherProtocol!
    var routerToDetail: RoutesToDetailItemViewController<ViewDataItemDetail>!
    var tableViewDelegate: PresentaAProductDetail!
    
    typealias ScreenViewControllerSearchAListOfDataProducts = UIViewController & ListsOfViewDataProducts
    
    typealias MercadoLibreSearcher = SearcherTerm<ProductHolder<MercadoLibreListingProduct>,SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, MercadolibreGetParser>>
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        //create the model
        productListHolder = createAMercadoLibreListingProductHolder()
        
        //prepare search objects
        let searcherNetworkService = createATermSearcherMercadoLibreNeworkService()
        
        //create a network traffic controller
        searcherNetworkTrafficController = NetworkSearchingTrafficDelegate()
        searcherNetworkService.delegate = searcherNetworkTrafficController
        
        let searcherService: MercadoLibreSearcher = createASearcherObject(with: searcherNetworkService,
                                                                          and: productListHolder!) as! SceneDelegate.MercadoLibreSearcher
        //middle object to throtleSearch search events.
        throtleSearch = createAsearcherThrotle(with: searcherService)
        
        //create a delegate UISearchResultsUpdating to be used in the search controller needed in the search screen.
        searchResultsUpdatingDelegate = createASearchBarUpdatingDelegate(with: throtleSearch)
        
        //create a searchController.
        let searchController = createASearchcontroller(with: searchResultsUpdatingDelegate!)
        
        //create a "router to a detail" object to be used by the search screen.
        routerToDetail = RoutesToDetailItemViewController()
        
        //create a tableview delegate to be assigned to the search table view screen.
        tableViewDelegate = PresentaAProductDetail()
        tableViewDelegate.delegate = routerToDetail
        
        let searchScreenNav = createATableViewSearchScreenNavigationControllerWith(with: searchController,
                                                                                   andTableViewDelegate: tableViewDelegate)
        //Assign router delegate and its navigation controller so it can control the navigation.
        assignRouterDelegate(vc: searchScreenNav!, to: routerToDetail)
        
        //Assign searcherNetworkTrafficController delegate
        assignSearcherNetworkTrafficController(with: searchScreenNav!, to: searcherNetworkTrafficController!)
        
        //listen to any search events.
        searchBroadCaster = BroadcastSearcherTermDelegateMessages()
        searchBroadCaster.recipients.append(searcherNetworkService) // so It can cancel any tasks to be made.
        searchBroadCaster.recipients.append(searcherNetworkTrafficController!)
        
        //create a presenter to present the list of products from the model.
        presenterProductList = createApresenter(from: searchScreenNav!, with: productListHolder!)
        
        //presenter listen to changes in the observer
        if let presenterProductList = presenterProductList {
            productListHolder!.observer = presenterProductList
        }
        
        //assign the searchBroadCaster to the searcherService's delegate so it can broadcast the message.
        searcherService.delegate = searchBroadCaster
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreenNav
        window?.makeKeyAndVisible()
    }
    
    func createApresenter(from vc: UIViewController,
                          with: ListOfProductsPrensenterModelProtocol) -> ListOfProductsPrensenter? {

        guard let viewWithPresentableListOfProducts = (vc as? UINavigationController)?.topViewController as? ScreenViewControllerSearchAListOfDataProducts else {
            return nil
        }
        
        return ListOfProductsPrensenter(with: productListHolder!, and: viewWithPresentableListOfProducts)
    }
    
    func assignRouterDelegate(vc: UIViewController, to router: RoutesToDetailItemViewController<ViewDataItemDetail>){
        if let nav = vc as? UINavigationController,
            let routerDelegate = nav.topViewController as? RoutesToDetailItemViewControllerDelegate {
            router.routerDelegate = routerDelegate
            router.navigationController = nav
        }
    }
    
    func assignSearcherNetworkTrafficController(with vc: UIViewController,
                                                to searcherNetworkTrafficController: NetworkSearchingTrafficDelegate) {
        if let searchScreenSearchingTrafficDelegate  = (vc as? UINavigationController)?.topViewController as? SearchingTrafficDelegate {
            searcherNetworkTrafficController.delegate = searchScreenSearchingTrafficDelegate
        }
    }
    
    func createAsearcherThrotle(with searcher: SearcherProtocol) -> SearcherProtocol {
        return ThrotleSearch(searcher: searcher)
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
    
    func createATableViewSearchScreenNavigationControllerWith(with searchController: UISearchController,
                                                     andTableViewDelegate delegate: UITableViewDelegate) -> UIViewController? {
        return ViewControllerWithSearchFactory
        .viewController(for:
            .tableViewControllerForVisibleProductsWith(searchController: searchController,
                                                       andTableViewDelegate: delegate))
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

