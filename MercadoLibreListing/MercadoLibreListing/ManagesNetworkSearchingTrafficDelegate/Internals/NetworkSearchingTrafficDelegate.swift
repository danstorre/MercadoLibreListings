//
//  NetworkSearchingTrafficDelegate.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/13/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum NetworkSearchingTrafficDelegateError: Error {
    case noconnectivityError
    case serverError
    case appError
    case searchNotFound(with: String)
}

class NetworkSearchingTrafficDelegate: NetworkSearchingTraffic {

    weak var delegate: SearchingTrafficDelegate?
    var keepSearching: Bool = false
    private var lastNetworkError: WebserviceError?
    private var lastSearchError: SearcherTermError?
    
    //MARK: NetworkSearchingTrafficDelegate methods
    private func finishing() {
        if let errorToReturnMadeByNetwork = getErrorByNetworkService()  {
            delegate?.didFinishSearching(with: errorToReturnMadeByNetwork)
            return
        }
        if let errorToReturnMadeBySearchterm = getErrorBySearchTerm() {
            delegate?.didFinishSearching(with: errorToReturnMadeBySearchterm)
            return
        }
        if lastNetworkError == nil, lastSearchError == nil {
            delegate?.didFinishSearching()
        }
    }
    
    private func getErrorBySearchTerm() -> NetworkSearchingTrafficDelegateError?{
        guard let searchError = lastSearchError else {
            return nil
        }
        switch searchError {
        case .serviceReturnNilItems(withTerm: let term):
            return .searchNotFound(with: term)
        }
    }
    
    private func getErrorByNetworkService() -> NetworkSearchingTrafficDelegateError? {
        guard let networkError = lastNetworkError else {
            return nil
        }
        switch networkError {
        case .ResponseError(with: _, andCode: let statusCode):
            return getErrorFromCode(statusCode: statusCode)
        case .DataEmptyError:
            return .serverError
        case .ParsingError(with: _):
            return .appError
        }
    }
    
    private func getErrorFromCode(statusCode: Int) -> NetworkSearchingTrafficDelegateError {
        //TODO:- map status code to an error.
        //check if its is a network error or a data empty error.
        return .appError
    }
    
    //MARK: Search delegate methods
    func willSearch() {
        guard !keepSearching else { return }
        keepSearching = true
        lastNetworkError = nil
        lastSearchError = nil
        delegate?.didStartSearching()
    }
    
    //error after parsing data, maybe there is no items returned.
    func didFinish(with searchError: SearcherTermError) {
        lastSearchError = searchError
    }
    
    func didFinish() {
        lastSearchError = nil
    }
    
    //MARK: Network service delegate methods
    func didFinishAllCurrentTasks() {
        keepSearching = false
        finishing()
    }
    
    func didFinishWithoutErrors() {
        lastNetworkError = nil
    }
    
    func errorWhenCreatingURL(_ error: Error) {
        lastNetworkError = error as? WebserviceError
    }

    func errorWhenMakingANetworkRequest(_ error: Error) {
        lastNetworkError = error as? WebserviceError
    }
    
    func errorWhenParsingNerworkRequest(_ error: Error) {
        lastNetworkError = error as? WebserviceError
    }
}
