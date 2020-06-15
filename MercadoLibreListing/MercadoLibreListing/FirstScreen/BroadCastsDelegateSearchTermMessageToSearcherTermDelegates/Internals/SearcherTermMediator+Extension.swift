//
//  SearcherTermMediator+Extension.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension SearcherTermMediator {
    func willSearch() {
        for recipient in recipients { recipient.willSearch() }
    }
    func didFinish(with error: SearcherTermError) {
        for recipient in recipients { recipient.didFinish(with: error) }
    }
    func didFinish() {
        for recipient in recipients { recipient.didFinish() }
    }
}

