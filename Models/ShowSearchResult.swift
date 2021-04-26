//
//  ShowSearchResult.swift
//  Models
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import Foundation

public struct ShowSearchResult: Codable {
    public let score: Double
    public let show: Show
    
    public init(score: Double, show: Show) {
        self.score = score
        self.show = show
    }
}
