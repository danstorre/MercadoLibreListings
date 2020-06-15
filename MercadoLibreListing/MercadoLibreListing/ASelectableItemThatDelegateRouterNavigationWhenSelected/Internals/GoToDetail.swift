//
//  GoToDetail.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/8/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct NavigatesToItemDetails<T: ViewDataProductProtocol, E: NavigationDetailsUseCase>: ISelectable, ViewDataProductProtocol where T == E.T{
    var imageThumnail: UIImage? {
        get {
            return item.imageThumnail
        }
        set {
            item.imageThumnail = newValue
        }
    }
    
    var attributeTitleProduct: NSAttributedString?{
        get {
            return item.attributeTitleProduct
        }
        set {
            item.attributeTitleProduct = newValue
        }
    }
    
    var item: T
    var router: E
    
    init(with item: T, and router: E) {
        self.item = item
        self.router = router
    }
    
    func select() {
        router.gotoDetail(withItem: item)
    }
}

class RoutesToDetailItemViewController<ViewDataProductProtocol>: NavigationDetailsUseCase {
    var navigationController: UINavigationController?
    func gotoDetail(withItem selectedItem: ViewDataProductProtocol) {
    }
}
