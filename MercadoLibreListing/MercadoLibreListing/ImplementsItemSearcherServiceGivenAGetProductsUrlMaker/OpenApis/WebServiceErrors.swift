//
//  WebServiceErrors.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum WebserviceError : Error {
    case URLInvalidError(with: Error)
    case DataEmptyError
    case ParsingError(with: Error)
    case ResponseError(with:Error, andCode: Int)
}
