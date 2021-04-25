//
//  ShowDetails.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public struct ShowDetails {
    public let show: Show
    public let crew: [CrewMember]
    public let episodes: [Episode]
    
    public init(show: Show, crew: [CrewMember], episodes: [Episode]) {
        self.show = show
        self.crew = crew
        self.episodes = episodes
    }
}
