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
    var urlMaker: SearchProductMercadoLibreServiceProtocol
    var parser: ParserType?
    
    weak var delegate: SearchProductsUsingMercadoLibreGetServiceDelegate?
    
    init(urlMaker: SearchProductMercadoLibreServiceProtocol) {
        self.urlMaker = urlMaker
    }
    
    func getItems(with term: String, completion: @escaping (([ProductType]?) -> ())) {
        let url = urlMaker.makeGetProductsUrl(searchterm: term)
        
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            
            guard error == nil else {
                completion(nil)
                self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError.ResponseError)
                return
            }
            
            guard let data = data else {
                completion(nil)
                self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError.DataEmptyError)
                return
            }
            
            do {
                let items = try self?.parser?.decode(data: data)
                completion(items)
            }catch let error {
                completion(nil)
                self?.delegate?.errorWhenMakingANetworkRequest(error)
            }
        }
        task.resume()
    }
}
