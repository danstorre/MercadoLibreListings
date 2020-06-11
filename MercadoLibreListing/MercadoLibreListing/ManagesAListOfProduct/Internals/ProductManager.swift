//
//  ProductManager.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class ProductHolder<T: ProductProtocol>: ItemHolder{
    var products: [T]
    
    init(products: [T]) {
        self.products = products
    }
    
    func getItems() -> [T] {
        return products
    }
    
    func save(items: [T]) {
        self.products = items
    }
}
