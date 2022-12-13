//
//  AppGroup.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 12.12.2022.
//

import Foundation
struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let name, artistName, artworkUrl100: String
    
}
