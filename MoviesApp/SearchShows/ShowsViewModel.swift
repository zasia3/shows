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
import DataLoader

protocol ShowsViewModelDelegate: AnyObject {
    func didReceiveShows()
    func didClearData()
    func didReceiveError(_ error: APIError)
    func didRetrieveShowDetails(_ details: ShowDetails)
    func didUpdateCell(at index: Int)
    
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
    private var favouritesHandler: ShowsStorageProtocol
    private var detailsLoader: DetailsLoaderProtocol
    private var imagesLoader: ImagesLoaderProtocol
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
    
    init(searchHandler: SearchHandlerProtocol, favouritesHandler: ShowsStorageProtocol, detailsLoader: DetailsLoaderProtocol, imagesLoader: ImagesLoaderProtocol) {
        self.searchHandler = searchHandler
        self.favouritesHandler = favouritesHandler
        self.detailsLoader = detailsLoader
        self.imagesLoader = imagesLoader
        super.init()
        self.searchHandler.delegate = self
    }
    
    func textDidChange(to term: String?) {
        defer {
            imagesLoader.cancelDownloading()
        }
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
        detailsLoader.loadDetails(of: filteredShows[indexPath.row]) { [weak self] showDetails in
            self?.delegate?.didRetrieveShowDetails(showDetails)
        }
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
        if let localUrl = show.image?.localUrl {
            cell.imageView?.image = UIImage(contentsOfFile: localUrl.path)
        } else {
            cell.imageView?.image = UIImage(systemName: "camera.on.rectangle")
            cell.imageView?.tintColor = UIColor(named: "Hero")
        }
        let imageName = show.isFavourite(in: favouritesHandler) ? "star.fill" : "star"
        cell.favouriteImageView.image = UIImage(systemName: imageName)
        return cell
    }
}

extension ShowsViewModel: SearchHandlerDelegate {
    func didFind(shows: [Show]) {
        self.shows = shows
        DispatchQueue.main.async {
            self.delegate?.didReceiveShows()
        }
        shows.enumerated().forEach { [weak self] index, show in
            if let url = show.image?.url {
                self?.downloadImage(fromUrl: url, index: index)
            }
        }
        
    }
    
    func downloadImage(fromUrl url: URL, index: Int) {
        imagesLoader.downloadFromUrl(url) { [weak self] progress in
            guard let self = self else { return }
            switch progress {
            case .downloaded(let url):
                guard self.shows.count > index else { return }
                self.shows[index].image?.localUrl = url
                DispatchQueue.main.async {
                    self.delegate?.didUpdateCell(at: index)
                }
            default:
                break
            }
        }
    }
    
    func didReceiveError(_ error: APIError) {
        DispatchQueue.main.async {
            self.delegate?.didReceiveError(error)
        }
    }
}
