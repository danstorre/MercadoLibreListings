//
//  RoutesToDetailItemViewController.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

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
