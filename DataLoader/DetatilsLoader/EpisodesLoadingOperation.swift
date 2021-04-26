//
//  EpisodesLoadingOperation.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Common
import API
import Models

public class EpisodesLoadingOperation: DetailsLoadingOperation {
    private let completion: (Result<[Episode], APIError>) -> Void
    
    public init(api: ShowDetailsAPIProtocol, showId: Int, completion: @escaping (Result<[Episode], APIError>) -> Void) {
        self.completion = completion
        super.init(api: api, showId: showId)
    }
    
    override public func main() {
        api.getEpisodes(showId: "\(showId)") { [weak self] result in
            guard let self = self else { return }
            self.completion(result)
            self.state = .finished
        }
    }
}
