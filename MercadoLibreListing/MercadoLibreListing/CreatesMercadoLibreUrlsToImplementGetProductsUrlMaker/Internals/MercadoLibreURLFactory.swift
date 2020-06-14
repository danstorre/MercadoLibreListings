//
//  MercadoLibreURLFactory.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

struct MercadoLibreURLFactory: GetProductsUrlMaker{
    func makeGetProductsUrl(searchterm: String) throws -> URL {
        //TODO:- make url to search products.
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mercadolibre.com"
        components.path = "/sites/MLA~ search"
        
        let queryItem = URLQueryItem(name: "q", value: searchterm)
        
        components.queryItems = [queryItem]
        guard let url = components.url else {
            throw MercadoLibreUrlError.GetUrlInvalid
        }
        
        return url
    }
}
