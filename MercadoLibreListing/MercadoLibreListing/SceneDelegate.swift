//
//  SceneDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol PresentaAProductDetailDelegate: class {
    func presentItemAt(indexPath: IndexPath)
}

class PresentaAProductDetail: NSObject, UITableViewDelegate {
    weak var delegate: PresentaAProductDetailDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.presentItemAt(indexPath: indexPath)
    }
}

extension ProductCellViewData: ViewDataItemDetail{
    var title: NSAttributedString? {
        return self.attributeTitleProduct
    }
    
    var image: UIImage? {
        return self.imageThumnail
    }
}

extension PresentableProductsTableViewController: RoutesToDetailItemViewControllerDelegate{
    func getItem(at index: IndexPath) -> ViewDataItemDetail {
        guard  !arrayOfViewDataProducts.isEmpty, arrayOfViewDataProducts.indices.contains(index.row),
            let modeitemDetail = arrayOfViewDataProducts[index.row] as? ViewDataItemDetail else{
                fatalError("a product should conform to ModelItemDetail")
        }
        
        return modeitemDetail
    }
}

protocol ViewDataItemDetail {
    var title: NSAttributedString? {get}
    var image: UIImage? {get}
}

protocol RoutesToDetailItemViewControllerDelegate: class {
    func getItem(at: IndexPath) -> ViewDataItemDetail
}

class RoutesToDetailItemViewController<ModelProductDetail>: NavigationDetailsUseCase {
    var navigationController: UINavigationController?
    
    weak var routerDelegate: RoutesToDetailItemViewControllerDelegate?
    
    func gotoDetail(withItem item: ViewDataItemDetail) {
        
        //TODO:- Plan
        //create a service with that model. (searches the needed thing about this model and mofies de model.)
        //create screen that conforms to presenter view data.
        //create a presenter with both presenter's model delegate an presenter's view data delegate.
        //presenter listen to model changes.
        //present the screen.
        
        //For the Test purposes this app will show just the contents of the item given by this function.
        let storyBoard = UIStoryboard(name: "DetailScreen", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "DetailScreenViewController") as? DetailScreenViewController, let imageOfItem = item.image {
            vc.titleItem = item.title
            vc.imageOfItem = imageOfItem
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

extension RoutesToDetailItemViewController: PresentaAProductDetailDelegate {
    func presentItemAt(indexPath: IndexPath) {
        guard let productDetailModel = routerDelegate?.getItem(at: indexPath) else {return }
        gotoDetail(withItem: productDetailModel)
    }
}

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
            
        productListHolder = createAMercadoLibreListingProductHolder()
        
        routerToDetail = RoutesToDetailItemViewController()
        
        tableViewDelegate = PresentaAProductDetail()
        tableViewDelegate.delegate = routerToDetail
        
        let searcherNetworkService = createATermSearcherMercadoLibreNeworkService()
        searcherNetworkTrafficController = NetworkSearchingTrafficDelegate()
        searcherNetworkService.delegate = searcherNetworkTrafficController
        
        let searcherService: MercadoLibreSearcher = createASearcherObject(with: searcherNetworkService,
                                                                          and: productListHolder!) as! SceneDelegate.MercadoLibreSearcher
        throtleSearch = createAsearcherThrotle(with: searcherService)
        searchResultsUpdatingDelegate = createASearchBarUpdatingDelegate(with: throtleSearch)
        
        let searchController = createASearchcontroller(with: searchResultsUpdatingDelegate!)
        
        let searchScreenNav = createATableViewSearchScreenNavigationControllerWith(with: searchController,
                                                                                   andTableViewDelegate: tableViewDelegate)
        //Assign router delegate
        if let nav = searchScreenNav as? UINavigationController,
            let routerDelegate = nav.topViewController as? RoutesToDetailItemViewControllerDelegate {
            routerToDetail.routerDelegate = routerDelegate
            routerToDetail.navigationController = nav
        }
        
        //Assign searcherNetworkService delegate
        if let searchScreenSearchingTrafficDelegate  = (searchScreenNav as? UINavigationController)?.topViewController as? SearchingTrafficDelegate {
            searcherNetworkTrafficController?.delegate = searchScreenSearchingTrafficDelegate
        }
        
        searchBroadCaster = BroadcastSearcherTermDelegateMessages()
        searchBroadCaster.recipients.append(searcherNetworkService)
        searchBroadCaster.recipients.append(searcherNetworkTrafficController!)
        
        
        if let aScreenThatsSearcherTermDelegate = (searchScreenNav as? UINavigationController)?.topViewController as? SearcherTermDelegate {
            searchBroadCaster.recipients.append(aScreenThatsSearcherTermDelegate)
        }
        
        //create a presenter
        if let viewWithPresentableListOfProducts = (searchScreenNav as? UINavigationController)?.topViewController as? ScreenViewControllerSearchAListOfDataProducts {
            presenterProductList = ListOfProductsPrensenter(with: productListHolder!,
                                         and: viewWithPresentableListOfProducts)
            productListHolder!.observer = presenterProductList
        }
        
        searcherService.delegate = searchBroadCaster
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreenNav
        window?.makeKeyAndVisible()
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

