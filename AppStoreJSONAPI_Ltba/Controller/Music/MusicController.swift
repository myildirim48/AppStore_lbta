//
//  MusicController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 27.12.2022.
//

import UIKit
class MusicController: BaseListController,UICollectionViewDelegateFlowLayout {
    
    fileprivate let trackCellID = "trackCellID"
    fileprivate let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: trackCellID)
        
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
    }
    
    var results = [Result]()
    
    fileprivate let searchTerm = "taylor"
    
    fileprivate func fetchData() {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=25&limit=25"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult:SearchResult?,err) in
            
            if let err = err {
                print("Error fetch data",err)
            }
            
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! MusicLoadingFooter
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    var isPagination = false
    var isDonePagination = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackCellID, for: indexPath) as! TrackCell
        
        let track = results[indexPath.item]
        cell.nameLabel.text = track.trackName
        cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
        cell.subtitleLabel.text = "\(track.artistName ?? "") ⦁ \(track.collectionName ?? "")"
        
        //Initiate pagination
        if indexPath.item == results.count - 1 && !isPagination{
            
            print("fetch more data")
            
            isPagination = true
            
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=25"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult:SearchResult?,err) in
                
                if let err = err {
                    print("Error fetch data",err)
                }
                
                if searchResult?.results.count == 0 {
                    self.isDonePagination = true
                }
                
                sleep(3)
                
                
                self.results += searchResult?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPagination = false
                
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = isDonePagination ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
}
