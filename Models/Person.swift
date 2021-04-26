//
//  Person.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public struct Person: Decodable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
