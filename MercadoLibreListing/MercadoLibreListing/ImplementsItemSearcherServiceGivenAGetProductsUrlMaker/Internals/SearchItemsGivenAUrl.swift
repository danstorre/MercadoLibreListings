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
    
    func getItems(with term: String, completion: @escaping (([ProductType]?) -> ())) {
        let url: URL!
        do {
            url = try urlMaker.makeGetProductsUrl(searchterm: term)
        } catch let error{
            delegate?.errorWhenMakingANetworkRequest(error)
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil)
                    self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError.ResponseError)
                    self?.lastStepAfterFinishingATask()
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    self?.delegate?.errorWhenMakingANetworkRequest(WebserviceError.DataEmptyError)
                    self?.lastStepAfterFinishingATask()
                    return
                }
                
                do {
                    let items = try self?.parser?.decode(data: data)
                    completion(items)
                }catch let error {
                    completion(nil)
                    self?.delegate?.errorWhenMakingANetworkRequest(error)
                }
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
