//
//  SearchHandler.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import Foundation
import API
import Models

protocol SearchHandlerDelegate: AnyObject {
    func didFind(shows: [Show])
    func didReceiveError(_ error: APIError)
}

protocol SearchHandlerProtocol {
    var delegate: SearchHandlerDelegate? { get set }
    func search(for term: String)
}

class SearchHandler: SearchHandlerProtocol {
    
    private let api: APIProtocol
    
    weak var delegate: SearchHandlerDelegate?
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func search(for term: String) {
        guard term.count > 2 else { return }
        api.getShows(searchTerm: term) { [weak self] result in
            switch result {
            case .success(let shows):
                self?.delegate?.didFind(shows: shows)
            case .failure(let error):
                self?.delegate?.didReceiveError(error)
            }
        }
    }
}
