//
//  BaseListController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 10.12.2022.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout:
                    UICollectionViewFlowLayout())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
}
