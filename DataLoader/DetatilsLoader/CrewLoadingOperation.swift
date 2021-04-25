//
//  CrewLoadingOperation.swift
//  Common
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Common
import API
import Models

public class CrewLoadingOperation: DetailsLoadingOperation {
    private let completion: (Result<[CrewMember], APIError>) -> Void
    
    public init(api: APIProtocol, showId: Int, completion: @escaping (Result<[CrewMember], APIError>) -> Void) {
        self.completion = completion
        super.init(api: api, showId: showId)
    }
    
    override public func main() {
        api.getCrew(showId: "\(showId)") { [weak self] result in
            guard let self = self else { return }
            self.completion(result)
            self.state = .finished
        }
    }
}
