//
//  ControlFlow.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class NavigationDetailFlowSelection: SelectableCollection {

    var selectableItemsThatNavigateToItemDetails: [NavigatesToItemDetails<MercadoLibreListingProduct, RoutesToDetailItemViewController<MercadoLibreListingProduct>>] = []
    let router: RoutesToDetailItemViewController<MercadoLibreListingProduct>
    
    init(router: RoutesToDetailItemViewController<MercadoLibreListingProduct>) {
        self.router = router
    }
    
    func getSelectableItemAt(indexPath : IndexPath) -> ISelectable? {
        guard !selectableItemsThatNavigateToItemDetails.isEmpty,
            selectableItemsThatNavigateToItemDetails.indices.contains(indexPath.row) else {
                return nil
        }
        return selectableItemsThatNavigateToItemDetails[indexPath.row]
    }
}
