//
//  MercadolibreGetParser.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation


class MercadolibreGetParser: ParserProtocol {
    typealias T = [MercadoLibreListingProduct]
    
    func decode(data: Data) throws -> [MercadoLibreListingProduct] {
        let jsonParser = JsonParser<MercadoLibreGetServiceModel>()
        let mercadoLibreGetServiceModel = try jsonParser.decode(data: data)
        return mercadoLibreGetServiceModel.mercadoLibreProductListings
    }
}
