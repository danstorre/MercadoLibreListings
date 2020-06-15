//
//  ListsOfViewProducts.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

//PRODUCT LIST VIEW PROTOCOL
protocol ListsOfViewDataProducts {
    var arrayOfViewDataProducts: [ViewDataProductProtocol] { get set }
    func prensent(viewData: [ViewDataProductProtocol])
    func present(imageViewData: UIImage, at: Int)
}
