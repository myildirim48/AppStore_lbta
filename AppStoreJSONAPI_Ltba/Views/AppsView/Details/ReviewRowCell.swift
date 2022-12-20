//
//  ReviewRowCell.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 20.12.2022.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let reviewRatingLabel = UILabel(text: "Reviews & Rating", font: .boldSystemFont(ofSize: 20))
    
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(reviewRatingLabel)
        addSubview(reviewsController.view)
        
//        reviewsController.view.fillSuperview()
        
        reviewRatingLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        reviewsController.view.anchor(top: reviewRatingLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
}
