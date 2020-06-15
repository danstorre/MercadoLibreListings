//
//  SearchControllerFactoryOptions.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum SearchControllerFactoryOptions {
    case normal(withText: String?)
    case normalWith(text: String?, andDelegate: UISearchResultsUpdating)
}
