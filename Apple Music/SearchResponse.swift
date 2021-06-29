//
//  SearchResponse.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 16.06.2021.
//

import Foundation

struct SearchResponse: Codable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Codable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}
