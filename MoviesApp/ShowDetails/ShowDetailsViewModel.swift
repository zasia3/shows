//
//  ShowDetailsViewModel.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Models
import Common

protocol ShowDetailsViewModelDelegate: AnyObject {
    
}

protocol ShowDetailsViewModelProtocol {
    var delegate: ShowDetailsViewModelDelegate? { get set }
    var showDetails: ShowDetails { get }
    var crew: CrewMember? { get }
    var isFavourite: Bool { get }
    func toggleFavourite(_ add: Bool)
}

class ShowDetailsViewModel: ShowDetailsViewModelProtocol {
    private(set) var showDetails: ShowDetails
    private var favouritesHandler: Favourites
    weak var delegate: ShowDetailsViewModelDelegate?
    
    var crew: CrewMember? {
        showDetails.crew.first { $0.type == .creator } ?? showDetails.crew.first
    }
    
    var isFavourite: Bool {
        let favourites = favouritesHandler.favouriteShowIds()
        return favourites.contains(showDetails.show.id)
    }
    
    init(showDetails: ShowDetails, favouritesHandler: Favourites) {
        self.showDetails = showDetails
        self.favouritesHandler = favouritesHandler
    }
    
    func toggleFavourite(_ add: Bool) {
        if add {
            favouritesHandler.add(showDetails.show.id)
            return
        }
        favouritesHandler.delete(showDetails.show.id)
    }
}
