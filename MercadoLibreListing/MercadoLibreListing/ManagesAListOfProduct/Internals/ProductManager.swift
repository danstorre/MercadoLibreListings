//
//  ProductManager.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class ProductHolder: ItemHolder{
    var products: [ProductProtocol]
    
    init(products: [ProductProtocol]) {
        self.products = products
    }
    
    func getItems() -> [ProductProtocol] {
        return products
    }
    
    func save(items: [ProductProtocol]) {
        self.products = items
    }
}
