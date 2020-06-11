//
//  SearchTask.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

//UI Delegate object
protocol SearcherProtocol{
    func search(term: String)
}

//ModelRepresentation
protocol Item {}

//Repository
protocol ItemHolder: class {
    func getItems()-> [Item]
    func save(items: [Item])
}

//Public apis form SearcherTerm
protocol ItemSearcherService{
    func getItems(with: String, completion: @escaping(([Item]?) -> ()))
}

protocol SearcherTermDelegate: class{
    func didFinish(with: SearcherTermError)
}

enum SearcherTermError: Error {
    case serviceReturnNilItems
}

//search term internals
class SearcherTerm: SearcherProtocol{
    var repository: ItemHolder
    var service: ItemSearcherService
    weak var delegate: SearcherTermDelegate?
    
    convenience init(repository: ItemHolder,
                     service: ItemSearcherService,
                     delegate: SearcherTermDelegate) {
        self.init(repository: repository, service: service)
        self.delegate = delegate
    }
    
    init(repository: ItemHolder, service: ItemSearcherService){
        self.repository = repository
        self.service = service
    }
    
    func search(term: String) {
        service.getItems(with: term) {[weak self] (items) in
            guard let items = items else {
                self?.delegate?.didFinish(with: SearcherTermError.serviceReturnNilItems)
                return
            }
            self?.repository.save(items: items)
        }
    }
}


