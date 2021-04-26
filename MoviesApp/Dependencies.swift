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
    
    private lazy var downloadDirectory: URL? = {
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        let directory = url.appendingPathComponent("Download")
        
        do {
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return directory
    }()
    
    let api = API()
    let favourites = Storage()
    lazy var detailsLoader = DetailsLoader(api: api)
    lazy var imagesLoader = ImagesLoader(downloadDirectory: downloadDirectory)
    
    func setup() {
        let commands = CommandLine.arguments
        if commands.contains("--uitesting") {
            favourites.showsStorage.clear()
        }
    }
    
    func createSearchHandler() -> SearchHandlerProtocol {
        return SearchHandler(api: api)
    }
    
    func createShowsViewModel() -> ShowsViewModelProtocol {
        let searchHandler = createSearchHandler()
        return ShowsViewModel(searchHandler: searchHandler, favouritesHandler: favourites.showsStorage, detailsLoader: detailsLoader, imagesLoader: imagesLoader)
    }
    
    func createShowDetailsViewModel(showDetails: ShowDetails) -> ShowDetailsViewModelProtocol {
        return ShowDetailsViewModel(showDetails: showDetails, favouritesHandler: favourites.showsStorage)
    }
}
