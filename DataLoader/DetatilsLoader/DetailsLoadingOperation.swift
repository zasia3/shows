//
//  DetailsLoadingOperation.swift
//  DataLoader
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation
import Common
import API
import Models

open class DetailsLoadingOperation: AsynchronousOperation {
    let api: APIProtocol
    let showId: Int
    
    public init(api: APIProtocol, showId: Int) {
        self.api = api
        self.showId = showId
    }
}
