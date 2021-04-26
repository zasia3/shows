//
//  Episode.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public struct Episode: Decodable {
    public let id: Int
    public let name: String
    public let airdate: String
    public let airtime: String
    public let summary: String?
    
    public init(id: Int, name: String, airdate: String, airtime: String, summary: String?) {
        self.id = id
        self.name = name
        self.airdate = airdate
        self.airtime = airtime
        self.summary = summary
    }
}
