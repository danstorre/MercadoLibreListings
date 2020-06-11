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
    
    typealias TypeTest = Int
    
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
        let itemsSeachCatcher: MockItemHolder = createItemsHolder()
        let brokenService = createABrokenServiceItem()
        let searcher = createAsearcher(with: itemsSeachCatcher,
                                       and: brokenService,
                                       delegate: searcherDelegate)
        
        //when
        searcher.search(term: "cama")
        
        //delegate gets an error that service is down.
        check(searcherDelegate, gets: SearcherTermError.serviceReturnNilItems)
    }
    
    func testSearchTerm_GivenAText_WhenServiceReturns_ShouldNotifyDelegate(){
        //given
        let searcherDelegate = createSearcerDelegate()
        let itemsSeachCatcher: MockItemHolder = createItemsHolder()
        let itemService = createAServiceItem()
        let searcher = createAsearcher(with: itemsSeachCatcher,
                                       and: itemService,
                                       delegate: searcherDelegate)
        
        //when
        searcher.search(term: "cama")
        
        //delegate gets an error that service is down.
        checkDelegateIsNotify(searcherDelegate)
    }
    
    func checkDelegateIsNotify(_ searcherDelegate: SearcherTermDelegate,
                                   line: UInt = #line) {
        guard let mock = searcherDelegate as? MockerSearchDelegate else {
               XCTFail("searcherDelegate should get notify.", line: line)
           return
       }
        XCTAssertTrue(mock.didFinishGetsCalled)
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
    
    func createABrokenServiceItem() -> MockService {
        var mock = MockService()
        mock.fails = true
        return mock
    }
    
    func createSearcerDelegate() -> SearcherTermDelegate {
        let mock = MockerSearchDelegate()
        return mock
    }
    
    func createAsearcher(with itemHolder: MockItemHolder,
                         and service: MockService,
                         delegate: SearcherTermDelegate) -> SearcherProtocol {
        return SearcherTerm(repository: itemHolder,
                            service: service,
                            delegate: delegate)
    }

    func createAsearcher(with itemHolder: MockItemHolder,
        and service: MockService) -> SearcherProtocol {
        return SearcherTerm(repository: itemHolder, service: service)
    }

    func createItemsHolder() -> MockItemHolder {
        return MockItemHolder()
    }

    func createAServiceItem() -> MockService {
        return MockService()
    }
    
    //SearcherTermDelegate
    class MockerSearchDelegate: SearcherTermDelegate{
        var didFinishGetsCalled: Bool = false
        var errorReceived: Error?
        func didFinish(with error: SearcherTermError) {
            errorReceived = error
        }
        func didFinish() {
            didFinishGetsCalled = true
        }
    }
    
    struct MockService: ItemSearcherService {
        var fails: Bool = false
        func getItems(with: String, completion: @escaping (([TypeTest]?) -> ())) {
            fails ? completion(nil) : completion([TypeTest()])
        }
    }
    
    class MockItemHolder: ItemHolder {
        var items: [TypeTest] = []
        
        func getItems() -> [TypeTest] {
            return items
        }
        
        func save(items: [TypeTest]) {
            self.items = items
        }
    }
}
