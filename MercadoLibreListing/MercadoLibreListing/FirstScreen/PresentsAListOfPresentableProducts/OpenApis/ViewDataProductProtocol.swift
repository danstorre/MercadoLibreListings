//
//  ViewDataProductProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

//PRODUCT VIEW DATA PROTOCOL
protocol ViewDataProductProtocol {
    var imageThumnail: UIImage? {get set}
    var attributeTitleProduct: NSAttributedString? {get set}
}
