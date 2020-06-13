//
//  ItemSearcherService.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ItemSearcherService{
    associatedtype T
    func getItems(with: String, completion: @escaping(([T]?) -> ()))
}
