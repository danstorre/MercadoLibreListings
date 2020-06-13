//
//  SearchProductsUsingMercadoLibreGetServiceDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol SearchItemsFromNetworkGivenASearchTermDelegate: class {
    func didFinishAllCurrentTasks()
    func errorWhenCreatingURL(_: Error)
    func errorWhenMakingANetworkRequest(_: Error)
}
