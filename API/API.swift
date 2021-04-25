//
//  API.swift
//  API
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import UIKit
import Models

public enum APIError: Error {
    case invalidUrl
    case noMovies
    case noData
    case decode(String)
    case other(Error?)
}

public protocol APIProtocol {
    func getShows(searchTerm term: String, completion: @escaping (Result<[Show], APIError>) -> Void)
    func getCrew(showId: String, completion: @escaping (Result<[CrewMember], APIError>) -> Void)
    func getEpisodes(showId: String, completion: @escaping (Result<[Episode], APIError>) -> Void)
    func getImage(url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void)
}

public final class API: APIProtocol {
    typealias DecodeFunction<T: Decodable> = (Data) -> T?
    typealias APIResult<T: Decodable> = (Result<T, APIError>) -> Void

    private let session: URLSession
    
    private let baseUrl = "https://api.tvmaze.com"
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func getShows(searchTerm term: String, completion: @escaping (Result<[Show], APIError>) -> Void) {
        let url = URL(string: "\(baseUrl)/search/shows?q=\(term)")
        func decodeShow(_ data: Data) -> [Show] {
            guard let decodedResponse = try? JSONDecoder().decode([ShowSearchResult].self, from: data) else { return [] }
            return decodedResponse.compactMap { $0.show }
        }
        makeRequest(url, with: decodeShow, then: completion)
    }
    
    public func getCrew(showId: String, completion: @escaping (Result<[CrewMember], APIError>) -> Void) {
        let url = URL(string: "\(baseUrl)/shows/\(showId)/crew")
        makeRequest(url, with: decodeSimpleResponse, then: completion)
    }
    
    public func getEpisodes(showId: String, completion: @escaping (Result<[Episode], APIError>) -> Void) {
        let url = URL(string: "\(baseUrl)/shows/\(showId)/episodes")
        makeRequest(url, with: decodeSimpleResponse, then: completion)
    }
    
    public func getImage(url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        makeDownloadRequest(url, then: completion)
    }
    
    
    func makeRequest<T: Decodable>(_ url: URL?, with decodeFunction: @escaping DecodeFunction<T>, then completion: @escaping APIResult<T>) {
        
        guard let url = url else {
            completion(.failure(.invalidUrl))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let decodedData = decodeFunction(data) else {
                completion(.failure(.decode("Could not decode\(T.self)")))
                return
            }
                
            completion(.success(decodedData))
        }
        
        task.resume()
    }
    
    func makeDownloadRequest(_ url: URL, then completion: @escaping (Result<UIImage, APIError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            
//            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
                
//            guard let downloadDirectory = self.downloadDirectory else {
//                completion(.failure(.other(nil)))
//                return
//            }
        
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(.other(nil)))
            }
        }
        task.resume()
    }
    
    func decodeSimpleResponse<T: Decodable>(_ data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
