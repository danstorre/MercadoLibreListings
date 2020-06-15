//
//  ControlsChangesInSarchbarsTextAndDelegatesTheSearchTest.swift
//  MercadoLibreListingTests
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class ControlsChangesInSarchbarsTextAndDelegatesTheSearchTest: XCTestCase {

    func testupdateSearchResults_whenSearchBarChanges_thenSendsMessageToItsSearcher(){
        
        //given
        let searcher = createAsearcher()
        let aSearchBarResultsUpdatingDelegate = createUISearchResultsUpdating(with: searcher)
        let aSearchController = createAUISearchController(with: aSearchBarResultsUpdatingDelegate)
        
        aSearchController.searchBar.text = "cama"
        
        XCTAssertTrue(searcher.searchReceived)
    }
    
    func createUISearchResultsUpdating(with searcher: SearcherProtocol) -> UISearchResultsUpdating{
        return SearchBarResultsUpdating(searcher: searcher)
    }
    
    func createAUISearchController(with delegate: UISearchResultsUpdating) -> UISearchController{
        let serachController = UISearchController()
        serachController.searchResultsUpdater = delegate
        return  serachController
    }
    
    func createAsearcher() ->  MockSearcher {
        return MockSearcher()
    }
    
    class MockSearcher: SearcherProtocol{
        var searchReceived: Bool = false
        func search(term: String) {
            searchReceived = true
        }
    }
}
