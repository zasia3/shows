//
//  Dependencies.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import Foundation
import API
import Common

class Dependencies {
    
    let api = API()
    let favourites = Favourites()
    
    func createSearchHandler() -> SearchHandlerProtocol {
        return SearchHandler(api: api)
    }
    
    func createShowsViewModel() -> ShowsViewModelProtocol {
        let searchHandler = createSearchHandler()
        return ShowsViewModel(searchHandler: searchHandler, favouritesHandler: favourites)
    }
    
    func createShowDetailsViewModel(showDetails: ShowDetails) -> ShowDetailsViewModelProtocol {
        return ShowDetailsViewModel(showDetails: showDetails, favouritesHandler: favourites)
    }
}
