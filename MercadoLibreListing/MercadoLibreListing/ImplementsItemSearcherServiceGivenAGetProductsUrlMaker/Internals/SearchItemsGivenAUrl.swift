//
//  SearchItemsUsingMercadoLibreService.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class SearchItemsFromNetworkGivenASearchTerm<ProductType, ParserType: ParserProtocol>: ItemSearcherService where ParserType.T ==  [ProductType]{
    typealias T = ProductType
    
    lazy var session: URLSession = URLSession.shared
    var urlMaker: GetProductsUrlMaker
    var parser: ParserType?
    var currentTasks: [URLSessionDataTask] = []
    
    weak var delegate: SearchItemsFromNetworkGivenASearchTermDelegate?
    
    init(urlMaker: GetProductsUrlMaker) {
        self.urlMaker = urlMaker
    }
    
    func getItems(with term: String, completion: @escaping (([ProductType]?, String) -> ())) {
        let url: URL!
        do {
            url = try urlMaker.makeGetProductsUrl(searchterm: term)
        } catch let error{
            delegate?.errorWhenMakingANetworkRequest(error)
            completion(nil, term)
            return
        }
        
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil, term)
                    self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError
                    .ResponseError(with: error!, andCode: -1009))
                    self?.lastStepAfterFinishingATask()
                    return
                }
                
                guard let data = data else {
                    completion(nil, term)
                    //no data returned by the server.
                    if let httpResponse = response as? HTTPURLResponse {
                        //any web service error.
                        self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError
                            .ResponseError(with: error!, andCode: httpResponse.statusCode))
                    }
                    self?.lastStepAfterFinishingATask()
                    return
                }
                
                do {
                    let items = try self?.parser?.decode(data: data)
                    completion(items, term)
                }catch let parsingError {
                    completion(nil, term)
                    //app error when parsing.
                    self?.delegate?.errorWhenParsingNerworkRequest(WebserviceError
                        .ParsingError(with: parsingError))
                }
                self?.delegate?.didFinishWithoutErrors()
                self?.lastStepAfterFinishingATask()
            }
        }
        currentTasks.append(task)
        task.resume()
    }
    
    fileprivate func lastStepAfterFinishingATask(){
        if hasTasksRunning() {
            reset()
            sendMessageAllTasksFinished()
        }
    }
    
    fileprivate func hasTasksRunning() -> Bool {
        let runningTasks = currentTasks.filter { (task) -> Bool in
            return task.state == .running
        }
        
        return runningTasks.isEmpty
    }
    
    fileprivate func reset() {
        currentTasks = []
    }
    
    fileprivate func sendMessageAllTasksFinished() {
        delegate?.didFinishAllCurrentTasks()
    }
}
