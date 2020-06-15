//
//  RouterTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import MercadoLibreListing

class RouterTests: XCTestCase {
    
    func testPresentItemDetail_GivenAListOfItem_WhenSelectingOneOfThem_ShouldPresentTheDetailOfTheItem(){
        let navigationUseCase: MockNaviationUseCase = MockNaviationUseCase()
        let selectableItems = GivenASelectableArrayOfItemsThatGoToDetail(
                                                with: navigationUseCase)
        
        let givenFirstSelectableItem = selectableItems.first
        
        givenFirstSelectableItem?.select()
        
        XCTAssertTrue(navigationUseCase.gotoDetailWithItemGetsCalled)
    }
    
    func GivenASelectableArrayOfItemsThatGoToDetail<T: ProductProtocol, E: NavigationDetailsUseCase>
        (with navUseCase: E) -> [ISelectable] where T == E.T {
        let items = [NavigatesToItemDetails(item: MockItem() as! T,
                                            router: navUseCase)]
        return items
    }
    
    class MockNaviationUseCase: NavigationDetailsUseCase{
        typealias T = MockItem
        
        var gotoDetailWithItemGetsCalled: Bool = false

        func gotoDetail(withItem: MockItem) {
            gotoDetailWithItemGetsCalled = true
        }
    }
    
    class MockItem: ProductProtocol {
        var imagetThumbnailUrl: URL?
        var title: String
        init(){
            self.title = ""
        }
    }
}
