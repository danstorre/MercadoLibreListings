//
//  ProductListPresenter+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension ListOfProductsPrensenter: SearcherTermDelegate {
    func willSearch() {
        let arrayOfproducts = modelList.getArrayOfProducts()
        guard !arrayOfproducts.isEmpty else {
            return
        }
        let urlsFromPreviousSearch = arrayOfproducts.map { (product) -> URL? in
            return product.imagetThumbnailUrl
        }.compactMap { return $0 }
        for urlPreviousSearch in urlsFromPreviousSearch {
            URLSession.shared.getAllTasks { (tasks) in
                guard let urlTask =  tasks.first(where: { (task) -> Bool in
                    guard let urlFromTask = task.originalRequest?.url else {return false}
                    return urlPreviousSearch == urlFromTask
                }) else {
                    return
                }
                urlTask.cancel()
            }
        }
    }
    
    func didFinish(with: SearcherTermError) {
        
    }
    
    func didFinish() {
        
    }
}
