//
//  DetailsLoader.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import API
import Models

public protocol DetailsLoaderProtocol {
    func loadDetails(of show: Show, completion: @escaping (ShowDetails) -> Void)
}

public class DetailsLoader: DetailsLoaderProtocol {
    let api: ShowDetailsAPIProtocol
    var crew = [CrewMember]()
    var episodes = [Episode]()
    
    lazy var loadingQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Details loading queue"
        return queue
    }()
    
    public init(api: ShowDetailsAPIProtocol) {
        self.api = api
    }
    
    public func loadDetails(of show: Show, completion: @escaping (ShowDetails) -> Void) {

        let lastOperation = BlockOperation { [weak self] in
            guard let self = self else {
                return
            }
            
            let details = ShowDetails(show: show, crew: self.crew, episodes: self.episodes)
            DispatchQueue.main.async {
                completion(details)
            }
        }
        let crewOperation = CrewLoadingOperation(api: api, showId: show.id) { [weak self] result in
            if case let .success(crew) = result {
                self?.crew = crew
            }
        }
        
        let episodesOperation = EpisodesLoadingOperation(api: api, showId: show.id) { [weak self] result in
            if case let .success(episodes) = result {
                self?.episodes = episodes
            }
        }
        lastOperation.addDependency(crewOperation)
        lastOperation.addDependency(episodesOperation)
        loadingQueue.addOperation(crewOperation)
        loadingQueue.addOperation(episodesOperation)
        loadingQueue.addOperation(lastOperation)
    }
}
