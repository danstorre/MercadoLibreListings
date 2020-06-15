//
//  RoutesToDetailItemViewControllerDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol RoutesToDetailItemViewControllerDelegate: class {
    func getItem(at: IndexPath) -> ViewDataItemDetail
}
