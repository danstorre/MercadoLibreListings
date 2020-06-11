//
//  TextSearcherTests.swift
//  MercadoLibreListingTests
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class TextSearcherTests: XCTestCase {

    func testSearchTerm_GivenAText_ShouldLookOutForItems(){
        //given
        let itemsSeachCatcher = createItemsHolder()
        let itemService = createAServiceItem()
        let searcher = createAsearcher(with: itemsSeachCatcher,
                                       and: itemService)
        
        XCTAssertTrue(itemsSeachCatcher.getItems().isEmpty)
        
        //when
        searcher.search(term: "cama")
        
        //itemsHolder should have more items.
        XCTAssertTrue(!itemsSeachCatcher.getItems().isEmpty)
    }
    
    func testSearchTerm_GivenAText_WhenServiceIsDown_ShouldSendErrorToDelegate(){
        //given
        let searcherDelegate = createSearcerDelegate()
        let itemsSeachCatcher = createItemsHolder()
        let brokenService = createABrokenServiceItem()
        let searcher = createAsearcher(with: itemsSeachCatcher,
                                       and: brokenService,
                                       delegate: searcherDelegate)
        
        //when
        searcher.search(term: "cama")
        
        //delegate gets an error that service is down.
        check(searcherDelegate, gets: SearcherTermError.serviceReturnNilItems)
    }
    
    func check(_ searcherDelegate: SearcherTermDelegate,
               gets expectedError: Error,
               line: UInt = #line) {
        guard let mock = searcherDelegate as? MockerSearchDelegate,
            let error = mock.errorReceived as? SearcherTermError else {
                XCTFail("searcherDelegate should get an error.", line: line)
            return
        }
        XCTAssertEqual(expectedError as! SearcherTermError, error)
    }
    
    func createABrokenServiceItem() -> ItemSearcherService {
        var mock = MockService()
        mock.fails = true
        return mock
    }
    
    func createSearcerDelegate() -> SearcherTermDelegate {
        let mock = MockerSearchDelegate()
        return mock
    }
    
    func createAsearcher(with itemHolder: ItemHolder,
                         and service: ItemSearcherService,
                         delegate: SearcherTermDelegate) -> SearcherProtocol {
        return SearcherTerm(repository: itemHolder,
                            service: service,
                            delegate: delegate)
    }
    
    func createAsearcher(with itemHolder: ItemHolder,
        and service: ItemSearcherService) -> SearcherProtocol {
        return SearcherTerm(repository: itemHolder, service: service)
    }
    
    func createItemsHolder() -> ItemHolder {
        return MockItemHolder()
    }
    
    func createAServiceItem() -> ItemSearcherService {
        return MockService()
    }
    
    //SearcherTermDelegate
    class MockerSearchDelegate: SearcherTermDelegate{
        var errorReceived: Error?
        var expectation: XCTestExpectation?
        func didFinish(with error: SearcherTermError) {
            errorReceived = error
            expectation?.fulfill()
        }
    }
    
    struct MockService: ItemSearcherService {
        var fails: Bool = false
        func getItems(with: String, completion: @escaping (([Item]?) -> ())) {
            fails ? completion(nil) : completion([MockItem()])
        }
    }
    
    struct MockItem: Item {
    }
    
    class MockItemHolder: ItemHolder {
        var items: [Item] = []
        
        func getItems() -> [Item] {
            return items
        }
        
        func save(items: [Item]) {
            self.items = items
        }
    }
}
