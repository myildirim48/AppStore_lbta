//
//  TrackCell.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 27.12.2022.
//

import UIKit
class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Name Label", font: .boldSystemFont(ofSize: 16))
    let subtitleLabel = UILabel(text: "Subtitle Label", font: .systemFont(ofSize: 16),numberofLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "garden")
        imageView.constrainWidth(constant: 70)
        imageView.constrainHeight(constant: 70)
        
        let stackView = UIStackView(arrangedSubviews: [imageView,
                                                       VerticalStackView(arrangedSubviews: [nameLabel,subtitleLabel])],customSpacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
