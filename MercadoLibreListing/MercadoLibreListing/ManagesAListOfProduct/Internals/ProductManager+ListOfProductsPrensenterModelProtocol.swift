//
//  ProductManager+ListOfProductsPrensenterModelProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension ProductHolder: ListOfProductsPrensenterModelProtocol where T == MercadoLibreListingProduct {
    func getArrayOfProducts(with presenter: ListOfProductsPrensenterProtocol) {
        presenter.prepareListOfProductsViewData(with: products)
    }
}
 
