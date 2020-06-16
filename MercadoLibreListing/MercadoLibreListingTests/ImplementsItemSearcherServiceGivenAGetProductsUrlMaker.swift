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
    
    func testGetItems_WhenServerReturnsItems_ShouldMakeADataTask(){
        //given
        let termToSearch = "casa"
        let urlmaker = createProductsUrlMaker()
        let itemSearcherService: SearcherType? = createAnItemSercherService(with: urlmaker)
        let mockURLSession = MockURLSession()
        itemSearcherService?.session = mockURLSession
        
        itemSearcherService?.getItems(with: termToSearch,
        completion: { (_, _) in })
        
        XCTAssertNotNil(mockURLSession.completionHandler)
    }
    
    func testGetItems_CallsResumeOfDataTask() {
        let mockURLSession = MockURLSession()
        let itemSearcherService: SearcherType? = CreateACompleteSearcherService(with: mockURLSession)
        let termToSearch = "casa"
        itemSearcherService?.getItems(with: termToSearch,
        completion: { (_, _) in })
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }

    func CreateACompleteSearcherService<T: SearcherGivenAUrlMakerItemSearcherService>(with session: DataTaskMaker) -> T? {

        let urlmaker = createProductsUrlMaker()
        let itemSearcherService: SearcherType? = createAnItemSercherService(with: urlmaker)
        
        itemSearcherService?.session = session
        
        return itemSearcherService as? T
    }
    
    class MockURLSession: DataTaskMaker {
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        override func resume() {
            resumeGotCalled = true
        }
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
