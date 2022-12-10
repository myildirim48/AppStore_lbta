//
//  VerticalStackView.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 9.12.2022.
//

import UIKit
import Foundation

class VerticalStackView: UIStackView {

    init(arrangedSubviews : [UIView], spacing: CGFloat = 0){
        super.init(frame: .zero)
        self.spacing = spacing
        arrangedSubviews.forEach({addArrangedSubview($0)})
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
