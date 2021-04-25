//
//  ShowsViewModel.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import UIKit
import Models
import API
import Common

protocol ShowsViewModelDelegate: AnyObject {
    func didReceiveShows()
    func didClearData()
    func didReceiveError(_ error: APIError)
    func didRetrieveShowDetails(_ details: ShowDetails)
}
protocol ShowsViewModelProtocol: UITableViewDataSource {
    var delegate: ShowsViewModelDelegate? { get set }
    var shows: [Show] { get }
    func textDidChange(to term: String?)
    func filterFavourites(_ show: Bool)
    func selectedShow(at indexPath: IndexPath)
}

class ShowsViewModel: NSObject, ShowsViewModelProtocol {
    weak var delegate: ShowsViewModelDelegate?
    
    private var searchHandler: SearchHandlerProtocol
    private var favouritesHandler: Favourites
    var showFavourites = false
    var shows = [Show]()
    var filteredShows: [Show] {
        guard showFavourites else {
            return shows
        }
        
        let favourites = favouritesHandler.favouriteShowIds()
        return shows.compactMap { favourites.contains($0.id) ? $0 : nil }
    }

    var currentSearchTerm: String?
    
    init(searchHandler: SearchHandlerProtocol, favouritesHandler: Favourites) {
        self.searchHandler = searchHandler
        self.favouritesHandler = favouritesHandler
        super.init()
        self.searchHandler.delegate = self
    }
    
    func textDidChange(to term: String?) {
        guard let term = term,
              !term.isEmpty else {
            shows = []
            delegate?.didClearData()
            return
        }
        currentSearchTerm = term
        searchHandler.search(for: term)
    }
    
    func filterFavourites(_ show: Bool) {
        showFavourites = show
        delegate?.didReceiveShows()
    }
    
    func selectedShow(at indexPath: IndexPath) {
        let showDetails = ShowDetails(show: shows[indexPath.row], crew: [], episodes: [])
        delegate?.didRetrieveShowDetails(showDetails)
    }
}

extension ShowsViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCell.reuseIdentifier) as? ShowCell ?? ShowCell(style: .default, reuseIdentifier: ShowCell.reuseIdentifier)
        let show = filteredShows[indexPath.row]
        cell.titleLabel.text = show.name
        cell.imageUrl = show.image?.url
        return cell
    }
}

extension ShowsViewModel: SearchHandlerDelegate {
    func didFind(shows: [Show]) {
        self.shows = shows
        DispatchQueue.main.async {
            self.delegate?.didReceiveShows()
        }
    }
    func didReceiveError(_ error: APIError) {
        DispatchQueue.main.async {
            self.delegate?.didReceiveError(error)
        }
    }
}