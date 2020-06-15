//
//  MercadoLibreGetServiceModel+Decodable.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension MercadoLibreGetServiceModel: Decodable{
    enum GetServiceCodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: GetServiceCodingKeys.self)
        
        mercadoLibreProductListings = try results.decode([MercadoLibreListingProduct].self, forKey: .results)
    }
}
