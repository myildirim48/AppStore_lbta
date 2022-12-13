//
//  AppsPageController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 10.12.2022.
//

import Foundation
import UIKit

class AppsPageController: BaseListController,UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
     super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsGroupCell.self
                                , forCellWithReuseIdentifier: cellId)
        
        collectionView.register(AppPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    var groups = [AppGroup]()
    var socialApp = [SocialApp]()
    
    fileprivate func fetchData() {
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        
        //Help you sync your data fetches together
        let dispatchGroup = DispatchGroup()
        
        
        dispatchGroup.enter()
            Service.shared.fetchBooks { appGroup, err in
        dispatchGroup.leave()
                group1 = appGroup
        }
        
        dispatchGroup.enter()
            Service.shared.fetchAppsPaid { appGroup, err in
        dispatchGroup.leave()
          group2 = appGroup
        }
        
        dispatchGroup.enter()
            Service.shared.fetchApps { appGroup, err in
        dispatchGroup.leave()
          group3 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApp { apps, err in
            if let err = err {
                print("Error while fetching social app data", err)
                return
            }
            
            if let apps = apps {
                dispatchGroup.leave()
                self.socialApp = apps
            }
            
        }
        
        //completion
        dispatchGroup.notify(queue: .main){
            print("Completed your dispatch group tasks... ")
            
            self.activityIndicatorView.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            if let group = group3 {
                self.groups.append(group)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    //Header->
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApp
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }//:Header
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
  
}
