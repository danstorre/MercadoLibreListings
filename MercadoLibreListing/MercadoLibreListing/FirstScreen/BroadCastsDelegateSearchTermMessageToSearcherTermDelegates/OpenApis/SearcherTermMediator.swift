//
//  SearcherTermMediator.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol SearcherTermMediator: SearcherTermDelegate {
    var recipients: [SearcherTermDelegate] { get }
}
