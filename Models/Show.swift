//
//  Show.swift
//  Models
//
//  Created by Joanna Zatorska on 17/04/2021.
//

import Foundation

public struct Show: Decodable, Hashable {
    public static func == (lhs: Show, rhs: Show) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: Int
    public let name: String
    public let url: String
    public let image: Image?
    
    public init(id: Int, name: String, url: String, image: Image?) {
        self.id = id
        self.name = name
        self.url = url
        self.image = image
    }
}
