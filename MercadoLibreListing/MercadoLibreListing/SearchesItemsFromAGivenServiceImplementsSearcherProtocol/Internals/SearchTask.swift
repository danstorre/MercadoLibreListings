//
//  SearchTask.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

//search term internals
class SearcherTerm<RepoType: ItemHolder, ItemSearcherType: ItemSearcherService>: SearcherProtocol where ItemSearcherType.T == RepoType.T{
    var repository: RepoType
    var service: ItemSearcherType
    
    weak var delegate: SearcherTermDelegate?
    
    init(repository: RepoType, service: ItemSearcherType){
        self.repository = repository
        self.service = service
    }
    
    convenience init(repository: RepoType,
                     service: ItemSearcherType,
                     delegate: SearcherTermDelegate) {
        self.init(repository: repository, service: service)
        self.delegate = delegate
    }
    
    func search(term: String) {
        delegate?.willSearch()
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


