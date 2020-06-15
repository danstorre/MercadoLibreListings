//
//  ManagesAObservableListOfProductsImplementsItemHolderTests.swift
//  MercadoLibreListingTests
//
//  Created by Daniel Torres on 6/15/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class ManagesAObservableListOfProductsImplementsItemHolderTests: XCTestCase {
 
    func testObserver_givenalistofproducts_whenChangesHappens_ObserverIsNotified() {
        
        //given
        let aProductHolder = createAProductholder(withProducts: [MockItem()])
        let observer = createAnObserver()
        aProductHolder.observer = observer
        
        aProductHolder.save(items: [MockItem(), MockItem()])
        
        XCTAssertTrue(observer.willChangeCalled)
        XCTAssertTrue(observer.didChangeCalled)
        XCTAssertTrue(aProductHolder.getItems().count == 2)
    }
    
    func createAProductholder<T: ProductProtocol>(withProducts: [T]) -> ProductHolder<T> {
        return ProductHolder(products: withProducts)
    }
    
    func createAnObserver() -> MockObserver{
        return MockObserver()
    }
    
}

class MockObserver: IObserver{
    var willChangeCalled: Bool = false
    var didChangeCalled: Bool = false
    func willChange() {
        willChangeCalled = true
    }
    
    func didChange() {
        didChangeCalled = true
    }
}

class MockItem: ProductProtocol {
    var imagetThumbnailUrl: URL?
    var title: String = ""
}
