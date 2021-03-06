//
//  MercadoLibreListingProduct+ProductProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension MercadoLibreListingProduct: ProductProtocol {
    
    var imagetThumbnailUrl: URL? {
        get {
            return self.thumbnailURL
        }
        set {
        }
    }
}
