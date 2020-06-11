//
//  MercadoLibreProduct+Decodable.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension MercadoLibreListingProduct: Decodable{
    enum ProductCodingKeys: String, CodingKey {
        case title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ProductCodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
    }
    
}
