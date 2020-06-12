//
//  ListsOfViewProducts.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

//PRODUCT LIST VIEW PROTOCOL
protocol ListsOfViewProducts {
    var arrayOfViewDataProducts: [ViewDataProductProtocol] { get set }
    func prensent(viewData: [ViewDataProductProtocol])
}
