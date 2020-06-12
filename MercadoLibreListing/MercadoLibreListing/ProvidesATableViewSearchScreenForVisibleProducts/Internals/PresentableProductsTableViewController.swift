//
//  PresentableProductsTableViewController.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class PresentableProductsTableViewController: UITableViewController, ListsOfViewDataProducts {
    var arrayOfViewDataProducts: [ViewDataProductProtocol] = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return !arrayOfViewDataProducts.isEmpty ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfViewDataProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewWithTitleTableViewCell",
                                                       for: indexPath) as? ImageViewWithTitleTableViewCell else {
                                                        return UITableViewCell()
        }

        let productViewData = arrayOfViewDataProducts[indexPath.row]

        cell.titleLabel.attributedText = productViewData.attributeTitleProduct
        cell.thumbnailImageView.image = productViewData.imageThumnail

        return cell
    }
    
     func prensent(viewData: [ViewDataProductProtocol]) {
        self.arrayOfViewDataProducts = viewData
        tableView.reloadData()
     }
}
