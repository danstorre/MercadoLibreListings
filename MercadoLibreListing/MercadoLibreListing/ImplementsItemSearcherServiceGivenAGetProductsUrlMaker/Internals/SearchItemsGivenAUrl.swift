//
//  SearchItemsUsingMercadoLibreService.swift
//  MercadoLibreListing
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol DataTaskMaker {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : DataTaskMaker {}


class SearchItemsFromNetworkGivenASearchTerm<ProductType, ParserType: ParserProtocol>: SearcherGivenAUrlMakerItemSearcherService where ParserType.T ==  [ProductType]{
    typealias T = ProductType
    
    lazy var session: DataTaskMaker = URLSession.shared
    var urlMaker: GetProductsUrlMaker
    var parser: ParserType?
    var currentTasks: [URLSessionDataTask] = []
    
    weak var delegate: SearchItemsFromNetworkGivenASearchTermDelegate?
    
    required init(urlMaker: GetProductsUrlMaker) {
        self.urlMaker = urlMaker
    }
    
    func getItems(with term: String, completion: @escaping (([ProductType]?, String) -> ())) {
        let url: URL!
        do {
            url = try urlMaker.makeGetProductsUrl(searchterm: term)
        } catch let error{
            delegate?.errorWhenMakingANetworkRequest(WebserviceError.URLInvalidError(with: error))
            completion(nil, term)
            lastStepAfterFinishingATask()
            return
        }
        
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil, term)
                    let code = (error! as NSError).code
                    self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError
                    .ResponseError(with: error!, andCode: code))
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
                    } else {
                        self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError.DataEmptyError)
                    }
                    self?.lastStepAfterFinishingATask()
                    return
                }
                
                do {
                    let items = try self?.parser?.decode(data: data)
                    completion(items, term)
                }catch let parsingError {
                    //app error when parsing.
                    self?.delegate?.errorWhenParsingNerworkRequest(WebserviceError
                        .ParsingError(with: parsingError))
                    completion(nil, term)
                    self?.lastStepAfterFinishingATask()
                    return
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
