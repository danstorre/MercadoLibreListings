//
//  GoToDetail.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/8/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct NavigatesToItemDetails<T: ProductProtocol, E: NavigationDetailsUseCase>: ISelectable where T == E.T{
    var item: T
    var router: E
    
    func select() {
        router.gotoDetail(withItem: item)
    }
}

struct RoutesToDetailItemViewController<T: ProductProtocol>: NavigationDetailsUseCase {
    var navigationController: UINavigationController?
    func gotoDetail(withItem selectedItem: T) {
    }
}
