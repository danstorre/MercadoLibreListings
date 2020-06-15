//
//  ObserverProtocol.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/12/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol IObserver: class {
    func willChange()
    func didChange()
}
