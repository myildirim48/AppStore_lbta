//
//  TodayItem.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 22.12.2022.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    // Enum
    
    let cellType : CellType
    
    let apps: [FeedResult]
    
    enum CellType : String {
        case single,multiple
    }
    
}
