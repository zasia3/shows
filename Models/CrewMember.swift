//
//  CrewMember.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public enum CrewType: String, Decodable {
    case creator = "Creator"
    case producer = "Producer"
    case executiveProducer = "Executive Producer"
    case coExecutiveProducer = "Co-Executive Producer"
    case supervisingProducer = "Supervising Producer"
    case coProducer = "Co-Producer"
    case consultingProducer = "Consulting Producer"
    case associateProducer = "Associate Producer"
    case unknown
}

public struct CrewMember: Decodable {
    public let type: CrewType
    public let person: Person
    
    enum CodingKeys: CodingKey {
        case type, person
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        type = CrewType(rawValue: typeString) ?? .unknown
        person = try container.decode(Person.self, forKey: .person)
    }
}
