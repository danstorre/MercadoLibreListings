//
//  SearchItemsGivenAUrl+SearcherTermDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class ThrotleSearch: SearcherProtocol{
    private var searcher: SearcherProtocol
    private var activeSearch: String? = ""
    private var throtle = Timer()
    
    init(searcher: SearcherProtocol) {
        self.searcher = searcher
    }
    
    func search(term: String) {
        guard let activeSearch = activeSearch, activeSearch != term else {
            return
        }
        self.activeSearch = term
        setTimer()
    }
    
    private func setTimer() {
        guard !throtle.isValid else {
            return
        }
        
        throtle = Timer.scheduledTimer(timeInterval: 0.6,
                                       target: self,
                                       selector: #selector(fireSearch),
                                       userInfo: nil,
                                       repeats: false)
    }
    
    @objc
    private func fireSearch(){
        throtle.invalidate()
        guard let activeSearch = activeSearch else { return }
        
        DispatchQueue.main.async {
            self.searcher.search(term: activeSearch)
        }
    }
}

extension SearchItemsFromNetworkGivenASearchTerm: SearcherTermDelegate {
    func willSearch() {
    }
    
    func didFinish(with: SearcherTermError) {
        
    }
    
    func didFinish() {
        
    }
    
}
