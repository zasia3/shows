//
//  Show+favourite.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Models
import Common

extension Show {
    func isFavourite(in favouritesHandler: ShowsStorageProtocol) -> Bool {
        let favourites = favouritesHandler.favouriteShowIds()
        return favourites.contains(id)
    }
}
