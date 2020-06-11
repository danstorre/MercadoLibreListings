//
//  JsonDecoder.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class JsonParser<DecodableType: Decodable>: ParserProtocol{
    typealias T = DecodableType
    
    func decode(data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        let items = try jsonDecoder.decode(T.self, from: data)
        return items
    }
}
