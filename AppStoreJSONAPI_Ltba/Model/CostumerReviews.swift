//
//  CostumerReviews.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 20.12.2022.
//

import Foundation

struct CostumerReviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let title: Label
    let content: Label
    let author: Author
}

struct Author: Decodable{
    let name: Label
}

struct Label: Decodable {
    let label: String
}
