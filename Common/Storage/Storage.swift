//
//  Favourites.swift
//  Common
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public protocol StorageProtocol {
    var showsStorage: ShowsStorageProtocol { get }
}

public struct Storage: StorageProtocol {
    public private(set) var showsStorage: ShowsStorageProtocol
    
    let defaults: UserDefaults
    
    public init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
        
        showsStorage = ShowsStorage(defaults: defaults)
    }
}
