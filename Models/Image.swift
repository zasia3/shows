//
//  Image.swift
//  Models
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

public struct Image: Codable, Hashable {
    public let url: URL?
    public var localUrl: URL?
    
    enum CodingKeys: CodingKey {
        case medium
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageUrlString = try? container.decode(String.self, forKey: .medium)
        if let urlString = imageUrlString {
            url = URL(string: urlString)
        } else {
            url = nil
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(url?.absoluteString, forKey: .medium)
    }
}
