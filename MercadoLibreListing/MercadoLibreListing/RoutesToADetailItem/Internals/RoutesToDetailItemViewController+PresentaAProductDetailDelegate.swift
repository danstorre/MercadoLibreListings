//
//  RoutesToDetailItemViewController+PresentaAProductDetailDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension RoutesToDetailItemViewController: PresentaAProductDetailDelegate {
    func presentItemAt(indexPath: IndexPath) {
        guard let productDetailModel = routerDelegate?.getItem(at: indexPath) else {return }
        gotoDetail(withItem: productDetailModel)
    }
}
