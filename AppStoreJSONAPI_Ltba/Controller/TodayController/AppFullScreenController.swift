//
//  AppFullScreenController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 21.12.2022.
//

import UIKit

class AppFullScreenController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,options: .curveEaseOut) {
        
        if scrollView.contentOffset.y > 100 {
            self.floatingContainerView.transform = .init(translationX: 0, y: -120 )
        }else {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,options: .curveEaseOut) {
                self.floatingContainerView.transform = .identity
            }
        }
        }
   
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        view.clipsToBounds = true
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        
        setupCloseButtonFullScreen()
        
        setuoFloatingControl()
    }
    let floatingContainerView = UIView()
    
    @objc fileprivate func handleTap() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,options: .curveEaseOut) {
            self.floatingContainerView.transform = .init(translationX: 0, y: -120)
        }
    }
    
    fileprivate func setuoFloatingControl() {
        
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        
        
        view.addSubview(floatingContainerView)
        
        

        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor , trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: -90, right: 16),size: .init(width: 0, height: 90))
        
        let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //Add subviews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainHeight(constant: 68)
        imageView.constrainWidth(constant: 68)
        
        
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainHeight(constant: 32)
        getButton.constrainWidth(constant: 80)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [UILabel(text: todayItem?.title ?? "", font: .boldSystemFont(ofSize: 18)),UILabel(text: todayItem?.category ?? "", font: .systemFont(ofSize: 16))],spacing: 4),
            getButton
        ],customSpacing: 16)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
//        button.setImage(#imageLiteral(resourceName: "close_button.png"), for: .normal)
        return button
    }()
    
    fileprivate func setupCloseButtonFullScreen() {
        view.addSubview(closeButton)
       
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 12, left: 0, bottom: 0, right: 12),size: .init(width: 40, height: 40))
        
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        
        return UITableView.automaticDimension
    }
    

}
