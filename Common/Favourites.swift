//
//  Favourites.swift
//  Common
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public protocol FavouritesProtocol {
    func favouriteShowIds() -> [Int]
    func add(_ showId: Int)
    func delete(_ showId: Int)
    func clear()
}

public struct Favourites {
    let defaults: UserDefaults
    private let showsKey = "favourite_shows"
    
    public init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    public func favouriteShowIds() -> [Int] {
        
        return defaults.object(forKey: showsKey) as? [Int] ?? []
    }
        
    public func add(_ showId: Int) {
        
        guard var shows = defaults.object(forKey: showsKey) as? [Int] else {
            defaults.set([showId], forKey: showsKey)
            return
        }
    
        guard !shows.contains(showId) else { return }
        
        shows.append(showId)
        defaults.set(shows, forKey: showsKey)
    }
        
    public func delete(_ showId: Int) {
            
        guard var shows = defaults.object(forKey: showsKey) as? [Int] else {
            defaults.set([showId], forKey: showsKey)
            return
        }
            
        guard let index = shows.firstIndex(of: showId) else { return }
            
        shows.remove(at: index)
        defaults.set(shows, forKey: showsKey)
    }
        
    public func clear() {
        defaults.removeObject(forKey: showsKey)
    }
}
