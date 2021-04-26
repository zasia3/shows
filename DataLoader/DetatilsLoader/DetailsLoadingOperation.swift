//
//  DetailsLoadingOperation.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Common
import API

open class DetailsLoadingOperation: AsynchronousOperation {
    let api: ShowDetailsAPIProtocol
    let showId: Int
    
    public init(api: ShowDetailsAPIProtocol, showId: Int) {
        self.api = api
        self.showId = showId
    }
}
