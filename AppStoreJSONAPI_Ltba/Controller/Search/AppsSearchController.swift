//
//  AppsSearchController.swift
//  AppStoreJSONAPI_Ltba
////
//  AppsSearchController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 8.12.2022.
//

import UIKit
import SDWebImage


class AppsSearchController: BaseListController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    fileprivate let cellId = "id123"
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       collectionView.backgroundColor = .white
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        setupSearchBar()
    
//        fetchITunesApps()
        
    }
    
    fileprivate var appResults = [Result]()
    
//    SearchBar
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Service.shared.fetchApps(searchTerm: searchText) { (res,err) in
                self.appResults = res
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
//    Fetch data with API
    fileprivate func fetchITunesApps() {
        Service.shared.fetchApps(searchTerm: "instagram") { (results, err) in
            if let err = err {
                print("Failed to fecth apps:", err)
                return
            }
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.appResult = appResults[indexPath.row]
        return cell
    }
}
