//
//  ItemHolderProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

//Repository
protocol ItemHolder: class {
    func getItems()-> [Item]
    func save(items: [Item])
}
