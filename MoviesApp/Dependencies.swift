//
//  Dependencies.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import Foundation
import API
import Common
import DataLoader
import Models

class Dependencies {
    
    let api = API()
    let favourites = Favourites()
    lazy var detailsLoader = DetailsLoader(api: api)
    
    func createSearchHandler() -> SearchHandlerProtocol {
        return SearchHandler(api: api)
    }
    
    func createShowsViewModel() -> ShowsViewModelProtocol {
        let searchHandler = createSearchHandler()
        return ShowsViewModel(searchHandler: searchHandler, favouritesHandler: favourites, detailsLoader: detailsLoader)
    }
    
    func createShowDetailsViewModel(showDetails: ShowDetails) -> ShowDetailsViewModelProtocol {
        return ShowDetailsViewModel(showDetails: showDetails, favouritesHandler: favourites)
    }
}
