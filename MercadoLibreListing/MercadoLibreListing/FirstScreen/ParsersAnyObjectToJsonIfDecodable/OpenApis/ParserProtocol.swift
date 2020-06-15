//
//  ParserProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype T: Decodable
    func decode(data: Data) throws -> T
}
