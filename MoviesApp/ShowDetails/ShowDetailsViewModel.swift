//
//  ShowDetailsViewModel.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Models
import Common

protocol ShowDetailsViewModelProtocol {
    var showDetails: ShowDetails { get }
    var crew: CrewMember? { get }
    var isFavourite: Bool { get }
    func toggleFavourite(_ add: Bool)
}

class ShowDetailsViewModel: ShowDetailsViewModelProtocol {
    private(set) var showDetails: ShowDetails
    private var favouritesHandler: FavouritesProtocol
    
    var crew: CrewMember? {
        showDetails.crew.first { $0.type == .creator } ?? showDetails.crew.first
    }
    
    var isFavourite: Bool {
        showDetails.show.isFavourite(in: favouritesHandler)
    }
    
    init(showDetails: ShowDetails, favouritesHandler: FavouritesProtocol) {
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

