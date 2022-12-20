//
//  PreviewScreenShotsController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 20.12.2022.
//

import UIKit

class PreviewScreenShotsController: HorizontalSnappingController,UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var app: Result? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    class ScreenShotCell: UICollectionViewCell{
        
        
        let imageview = UIImageView(cornerRadius: 8)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            imageview.backgroundColor = .purple
            
            addSubview(imageview)
            imageview.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ScreenShotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenShotCell
       
        let screenShotUrl = self.app?.screenshotUrls[indexPath.item]
        cell.imageview.sd_setImage(with: URL(string: screenShotUrl ?? "" ))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: view.frame.height)
    }
}
