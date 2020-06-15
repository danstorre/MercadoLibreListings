//
//  ProductCellViewData+ViewDataItemDetail.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension ProductCellViewData: ViewDataItemDetail{
    var title: NSAttributedString? {
        return self.attributeTitleProduct
    }
    
    var image: UIImage? {
        return self.imageThumnail
    }
}
