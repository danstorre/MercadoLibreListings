//
//  ProductManager.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

typealias ObservableItemHolder = ItemHolder & Observable
class ProductHolder<T: ProductProtocol>: ObservableItemHolder{
    var products: [T] {
        willSet{
            observer?.willChange()
        }
        didSet{
            observer?.didChange()
        }
    }
    
    weak var observer: IObserver?
    
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
