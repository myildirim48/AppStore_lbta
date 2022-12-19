//
//  SearchResult.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 9.12.2022.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}
struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let artworkUrl100: String //App icon
    let screenshotUrls: [String]
    let formattedPrice: String
    let description: String
    let releaseNotes: String
    
    
}
