//
//  SearchTask.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation


//ModelRepresentation
protocol Item {}

//Repository
protocol ItemHolder: class {
    func getItems()-> [Item]
    func save(items: [Item])
}

protocol SearcherTermDelegate: class{
    func didFinish(with: SearcherTermError)
    func didFinish()
}

enum SearcherTermError: Error {
    case serviceReturnNilItems
}

//search term internals
class SearcherTerm: SearcherProtocol{
    var repository: ItemHolder
    var service: ItemSearcherService
    weak var delegate: SearcherTermDelegate?
    
    init(repository: ItemHolder, service: ItemSearcherService){
        self.repository = repository
        self.service = service
    }
    
    convenience init(repository: ItemHolder,
                     service: ItemSearcherService,
                     delegate: SearcherTermDelegate) {
        self.init(repository: repository, service: service)
        self.delegate = delegate
    }
    
    func search(term: String) {
        service.getItems(with: term) {[weak self] (items) in
            guard let items = items, !items.isEmpty else {
                self?.delegate?.didFinish(with: SearcherTermError.serviceReturnNilItems)
                return
            }
            self?.repository.save(items: items)
            self?.delegate?.didFinish()
        }
    }
}


