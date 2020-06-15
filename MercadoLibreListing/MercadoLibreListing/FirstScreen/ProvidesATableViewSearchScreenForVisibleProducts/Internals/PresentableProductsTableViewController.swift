//
//  PresentableProductsTableViewController.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct SelectableItemsPresenter<T: ViewDataProductProtocol, E: NavigationDetailsUseCase>: ListsOfViewDataProducts  where T == E.T{
    var arrayOfViewDataProducts: [ViewDataProductProtocol] = []
    var router: E
    var delegate: ListsOfViewDataProducts
    
    func prensent(viewData: [ViewDataProductProtocol]) {
        let selectableItems  = viewData.map { (viewData) -> ViewDataProductProtocol? in
            guard let productViewData = viewData as? T else {return nil}
            return  NavigatesToItemDetails(with: productViewData, and: router)
        }.compactMap{ return $0 }
        delegate.prensent(viewData: selectableItems)
    }
    
    func present(imageViewData: UIImage, at index: Int) {
        delegate.present(imageViewData: imageViewData, at: index)
    }
}

class PresentableProductsTableViewController: UITableViewController, ListsOfViewDataProducts {
    
    var arrayOfViewDataProducts: [ViewDataProductProtocol] = []
    var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        activity = UIActivityIndicatorView()
        activity.stopAnimating()
        activity.hidesWhenStopped = true
        
        let barbuttonitem = UIBarButtonItem(customView: activity)
        navigationItem.rightBarButtonItem = barbuttonitem
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 70
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
        if cell.thumbnailImageView.image == nil {
            cell.animate()
        }else {
            cell.stopAnimating()
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func prensent(viewData: [ViewDataProductProtocol]) {
        self.arrayOfViewDataProducts = viewData
        tableView.reloadData()
    }
    
    func present(imageViewData: UIImage, at row: Int) {
        guard  !arrayOfViewDataProducts.isEmpty,
            arrayOfViewDataProducts.indices.contains(row) else {
                return
        }
        arrayOfViewDataProducts[row].imageThumnail = imageViewData
        
        let indexPath = IndexPath(row: row, section: 0)
        guard tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false else {
            return
        }
        let cell = tableView(tableView,
                             cellForRowAt: indexPath) as! ImageViewWithTitleTableViewCell
        cell.setUpImageView(with: arrayOfViewDataProducts[row].imageThumnail!)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func toggleLoading(isHidden: Bool) {
        isHidden ? activity.stopAnimating() : activity.startAnimating()
    }
}
