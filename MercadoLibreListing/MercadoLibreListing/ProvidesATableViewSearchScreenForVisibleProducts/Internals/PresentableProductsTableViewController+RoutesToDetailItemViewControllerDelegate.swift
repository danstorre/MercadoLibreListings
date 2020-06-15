//
//  PresentableProductsTableViewController+RoutesToDetailItemViewControllerDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension PresentableProductsTableViewController: RoutesToDetailItemViewControllerDelegate{
    func getItem(at index: IndexPath) -> ViewDataItemDetail {
        guard  !arrayOfViewDataProducts.isEmpty, arrayOfViewDataProducts.indices.contains(index.row),
            let modeitemDetail = arrayOfViewDataProducts[index.row] as? ViewDataItemDetail else{
                fatalError("a product should conform to ModelItemDetail")
        }
        
        return modeitemDetail
    }
}
