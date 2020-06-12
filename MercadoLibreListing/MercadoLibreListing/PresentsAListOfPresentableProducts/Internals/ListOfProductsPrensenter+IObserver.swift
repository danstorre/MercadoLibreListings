//
//  ListOfProductsPrensenter+Observer.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension ListOfProductsPrensenter: IObserver {
    func willChange() {
        modelList.getArrayOfProducts(with: self)
    }
    
    func didChange() {
        // do some work after data model has finished changing
    }
}
