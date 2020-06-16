//
//  SearcherGivenAUrlMakerItemSearcherService.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol SearcherGivenAUrlMakerItemSearcherService: ItemSearcherService {
    var delegate: SearchItemsFromNetworkGivenASearchTermDelegate? { get set }
    init(urlMaker: GetProductsUrlMaker)
}
