//
//  Episode.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public struct Episode: Decodable {
    public let id: String
    public let name: String
    public let airdate: String
    public let airtime: String
    public let summary: String
}
