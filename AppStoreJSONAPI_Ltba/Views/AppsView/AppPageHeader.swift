//
//  AppPageHeader.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 12.12.2022.
//

import UIKit

class AppPageHeader: UICollectionReusableView {
    
    let appHeaderHorizontalController = AppHeaderHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .blue
        
        appHeaderHorizontalController.view.backgroundColor = .purple
        addSubview(appHeaderHorizontalController.view)
        appHeaderHorizontalController.view.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
