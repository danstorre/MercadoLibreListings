//
//  ItemsPresenterTests.swift
//  MercadoLibreListingTests
//
//  Created by Daniel Torres on 6/11/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class ItemsPresenterTests: XCTestCase {
    
    typealias ExpectableListsOfViewProducts = ListsOfViewProducts & NeedsExcpectation
    
    typealias ObservableListOfProductsPrensenterModelProtocol = ListOfProductsPrensenterModelProtocol & Observable

    typealias ObserverListOfProductsPrensenterProtocol = ListOfProductsPrensenterProtocol & IObserver

    //buscador con imágenes, iconos y texto
    func testPresentItems_WhenGivenAListOfProducts_ShouldSetATableview(){
        //given an observable object
        let observableObject = createObservableObjectThatConformsToListOfProductsPrensenterModelProtocol()
        var listOfProductsView = createAnExpectablePresentableTitleAndImageProductView()
        let expectedViewData = expectation(description: "ExpectectedlistOfProductsView")
        listOfProductsView.expectation = expectedViewData
        
        //and a presenter listening to changes on the model.
        let presenterListener = createAListOfProductsPrensenterProtocol(with: observableObject,
                                                                        and: listOfProductsView)
        
        observableObject.observer = presenterListener
        
        //when the object changes
        observableObject.observer?.willChange()
        observableObject.observer?.didChange()
        
        wait(for: [expectedViewData], timeout: 0.3)
        //then presenter should send a view data to the view.
        XCTAssertTrue(!listOfProductsView.arrayOfViewDataProducts.isEmpty)
    }
    
    func createAnExpectablePresentableTitleAndImageProductView() -> ExpectableListsOfViewProducts {
        return MockListsOfViewProducts()
    }
    
    func createAListOfProductsPrensenterProtocol(with
        prensentableModel: ListOfProductsPrensenterModelProtocol,
        and presentableView: ListsOfViewProducts) -> ObserverListOfProductsPrensenterProtocol{
        return ListOfProductsPrensenter(with: prensentableModel, and: presentableView)
    }
    
    func createObservableObjectThatConformsToListOfProductsPrensenterModelProtocol() -> ObservableListOfProductsPrensenterModelProtocol {
        return MockObservableModel()
    }
}

protocol NeedsExcpectation {
    var expectation: XCTestExpectation? {get set}
}

class MockListsOfViewProducts: ListsOfViewProducts, NeedsExcpectation {
    var arrayOfViewDataProducts: [ViewDataProductProtocol] = []
    var expectation: XCTestExpectation?
    
    func prensent(viewData: [ViewDataProductProtocol]) {
        self.arrayOfViewDataProducts = viewData
        expectation?.fulfill()
    }
}

class MockObservableModel: Observable{
    var observer: IObserver?
}

class MockProductProtocol: ProductProtocol {
    var imagetThumbnailUrl: URL? = nil
    var title: String = "a title product"
}

extension MockObservableModel: ListOfProductsPrensenterModelProtocol {
    func getArrayOfProducts(with presenter: ListOfProductsPrensenterProtocol) {
        presenter.setArrayOfProducts(with: [MockProductProtocol()])
    }
}

