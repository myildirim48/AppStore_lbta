//
//  TodayController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 21.12.2022.
//
import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
    
    //    fileprivate let cellId = "cellId"
    //    fileprivate let multipleAppCellID = "multipleAppCellID"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .systemGray4
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    var items = [TodayItem]()
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = .systemGray6
        
        collectionView.register(TodayCell.self,  forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        
    }
    
    fileprivate func fetchData() {
        //Dispatch group
        let dispatchGroup = DispatchGroup()
        var appsPaid: AppGroup?
        var appsFree: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchAppsPaid{ appGroup, err in
            if let err = err {
                print("Error while fetching data at TodayController",err)
                return
            }
            
            appsPaid = appGroup
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchApps { appGroup, err in
            if let err = err {
                print("Error while fetching data at TodayController",err)
                return
            }
            
            appsFree = appGroup
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            print("Finished fetching at TodayController")
            
            
            
            self.items = [
                
                TodayItem.init(category: "Daily List", title: appsPaid?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "This is a special tree like in avatar.", backgroundColor: .white,cellType: .single, apps: appsPaid?.feed.results ?? []),
                TodayItem.init(category: "Daily List", title: appsPaid?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white,cellType: .multiple, apps: appsPaid?.feed.results ?? []),
                TodayItem.init(category: "Daily List", title: appsFree?.feed.title ?? "",image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: appsFree?.feed.results ?? []),
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: UIColor(red: 1, green: 0.9765, blue: 0.6667, alpha: 1.0),cellType: .single, apps: [])]
            
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
        
    }
    
    var appFullscreenController: AppFullScreenController!
    
    
    fileprivate func showDailyFullscreen(_ indexPath: IndexPath) {
        let fullController =  TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        
        fullController.modalPresentationStyle = .fullScreen
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType{
        case .multiple :
            showDailyFullscreen(indexPath)
        default :
            showSingleAppFullscreen(indexPath: indexPath)
        }
        
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullScreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        //Setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        if appFullscreenController.tableView.contentOffset.y > 0{
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        if gesture.state == .changed {
            if translationY > 0 {
//                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - translationY / 1000
                
                scale = min(1,scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: 0.5)
                self.appFullscreenController.view.transform = transform
            }
            
        }else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        // Auto layout constraint animations
        
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraint = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),size: .init(width: startingFrame.width, height: startingFrame.height))

        self.view.layoutIfNeeded() // starts animation
    }
    
    var anchoredConstraint: AnchoredConstraints?
    
    fileprivate func beginFullscreenAnimation(_ indexPath: IndexPath) {
        //Animation from cell to fullscreen
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.anchoredConstraint?.top?.constant = 0
            self.anchoredConstraint?.leading?.constant = 0
            self.anchoredConstraint?.width?.constant = self.view.frame.width
            self.anchoredConstraint?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            //            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath){
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2 Setup fullscreen in its starting position
        
      setupAppFullscreenStartingPosition(indexPath)
        
        // #3 Begin the fullscreen animation
        beginFullscreenAnimation(indexPath)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullscreenDismissal()  {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.appFullscreenController.tableView.contentOffset = .zero
            self.appFullscreenController.view.transform = .identity
            
            self.blurVisualEffectView.alpha = 0
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraint?.top?.constant = startingFrame.origin.y
            self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraint?.width?.constant = startingFrame.width
            self.anchoredConstraint?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
            
//            cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        return cell
    }
    @objc fileprivate func handleMultipleAppsTap(gestue: UIGestureRecognizer) {
        let collectionView = gestue.view
        
        var superview = collectionView?.superview
        while superview != nil {
            
            if let cell = superview as? TodayMultipleAppCell {
                
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
            }
            superview = superview?.superview
        }
        
        
    }
    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
