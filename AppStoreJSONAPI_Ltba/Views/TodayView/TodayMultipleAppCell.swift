//
//  TodayMultipleAppCell.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 23.12.2022.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    let categoryLabel = UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your time", font: .boldSystemFont(ofSize: 28),numberofLines: 2)
    
    
   override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            multipleAppsController.apps = todayItem.apps
            multipleAppsController.collectionView.reloadData()
        }
    }
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
                
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            multipleAppsController.view],spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
