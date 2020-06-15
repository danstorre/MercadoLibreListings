//
//  PresentaAProductDetail.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresentaAProductDetail: NSObject, UITableViewDelegate {
    weak var delegate: PresentaAProductDetailDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.presentItemAt(indexPath: indexPath)
    }
}
