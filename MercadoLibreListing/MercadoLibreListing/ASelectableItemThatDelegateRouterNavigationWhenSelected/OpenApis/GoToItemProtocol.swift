//
//  GoToItemProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol NavigationDetailsUseCase: class{
    associatedtype T
    func gotoDetail(withItem: T)
}
