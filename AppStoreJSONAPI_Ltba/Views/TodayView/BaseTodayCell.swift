//
//  BaseTodayCell.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 23.12.2022.
//

import UIKit
class BaseTodayCell: UICollectionViewCell {
    var todayItem : TodayItem!
    
    override var isHighlighted: Bool {
        didSet{
            let transfrom: CGAffineTransform = .identity
            
            if isHighlighted {
                    transform = .init(scaleX: 0.9, y: 0.9)
                
            }else {
                print("is highlighted : \(isHighlighted)")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                    self.transform = transfrom
                }
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shouldRasterize = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
