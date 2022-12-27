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
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let artworkUrl100: String //App icon
    var screenshotUrls: [String]?
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
    
    
}
