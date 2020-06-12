//
//  ListOfProductsPrensenterProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

//PRODUCT LIST PRESENTER PROTOCOL
protocol ListOfProductsPrensenterProtocol {
    func prepareListOfProductsViewData(with: [ProductProtocol])
}
