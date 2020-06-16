//
//  ImplementsItemSearcherServiceGivenAGetProductsUrlMaker.swift
//  MercadoLibreListingTests
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class ImplementsItemSearcherServiceGivenAGetProductsUrlMaker: XCTestCase {

    typealias SearcherType = SearchItemsFromNetworkGivenASearchTerm<MockItem, ParserMock>
    
    func testGetItems_GivenATerm_ShouldCallAnUrlMaker(){
        //given
        let termToSearch = "casa"
        let urlmaker = createProductsUrlMaker()
        let itemSearcherService: SearcherType? = createAnItemSercherService(with: urlmaker)
        
        itemSearcherService?.getItems(with: termToSearch,
                                      completion: { (_, _) in })
        
        XCTAssertTrue(urlmaker.makeGetUrlCalled)
    }
    
    func createProductsUrlMaker() -> MockURLMaker {
        return MockURLMaker()
    }
    
    func createAnItemSercherService<T: SearcherGivenAUrlMakerItemSearcherService>(
        with urlMaker: GetProductsUrlMaker) -> T? {
        let searcher = SearchItemsFromNetworkGivenASearchTerm<MockItem, ParserMock>(urlMaker: urlMaker)
        return searcher as? T
    }
    
    class MockURLMaker: GetProductsUrlMaker{
        var makeGetUrlCalled: Bool = false
        func makeGetProductsUrl(searchterm: String) throws -> URL {
            makeGetUrlCalled = true
            return URL(string: "https://www.google.com")!
        }
    }
    
    class URLMaker: SearchItemsFromNetworkGivenASearchTermDelegate {
        func didFinishWithoutErrors() {
        }
        
        func didFinishAllCurrentTasks() {
        }
        
        func errorWhenCreatingURL(_: Error) {
        }
        
        func errorWhenMakingANetworkRequest(_: Error) {
        }
        
        func errorWhenParsingNerworkRequest(_: Error) {
        }
    }
    
    struct ParserMock: ParserProtocol {
        func decode(data: Data) throws -> [MockItem] {
            return [MockItem()]
        }
    }
    
    struct MockItem: Decodable {
    }
}
