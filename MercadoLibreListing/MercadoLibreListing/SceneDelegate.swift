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
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        productListHolder = ProductHolder(products: [MercadoLibreListingProduct]())
      
        let searcherNetworkService = SearchItemsFromNetworkGivenASearchTerm<MercadoLibreListingProduct, JsonParser>(urlMaker: MercadoLibreURLFactory())
        searcherNetworkService.parser = JsonParser()
        
        let searcherService = SearcherTerm(repository: productListHolder!,
                                           service: searcherNetworkService)
        let searchController = SearchControllerFactory
            .searchController(for: .normalWith(text: nil,
                andDelegate: SearchBarResultsUpdating(searcher: searcherService)))
        
        let searchScreen = ViewControllerWithSearchFactory
            .viewController(for:
                .viewcontroller(withSearchController: searchController))
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = searchScreen
        window?.makeKeyAndVisible()
    }
    
    
    
}

