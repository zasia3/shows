//
//  CrewMember.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public enum CrewType: String, Decodable {
    case creator = "Creator"
    case executiveProducer = "Executive Producer"
    case coExecutiveProducer = "Co-Executive Producer"
    case supervisingProducer = "Supervising Producer"
    case coProducer = "Co-Producer"
    case consultingProducer = "Consulting Producer"
    case associateProducer = "Associate Producer"
}

public struct CrewMember: Decodable {
    public let type: CrewType
    public let person: Person
    
}
