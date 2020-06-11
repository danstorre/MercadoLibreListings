//
//  SearchItemsUsingMercadoLibreService.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class SearchProductsUsingMercadoLibreGetService<ProductType, ParserType: ParserProtocol>: ItemSearcherService where ParserType.T ==  [ProductType]{
    typealias T = ProductType
    
    lazy var session: URLSession = URLSession.shared
    var urlMaker: SearchProductMercadoLibreServiceProtocol?
    var parser: ParserType?
    
    weak var delegate: SearchProductsUsingMercadoLibreGetServiceDelegate?
    
    func getItems(with: String, completion: @escaping (([ProductType]?) -> ())) {
        
    }
}
