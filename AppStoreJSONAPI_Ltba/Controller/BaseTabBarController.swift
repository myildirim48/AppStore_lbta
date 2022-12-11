//
//  BaseTabBarController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 8.12.2022.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewControllers = [
            createNavController(viewController: AppsController(), title: "Apps", imageName: "apps"),
        createNavController(viewController: UIViewController(), title: "Today", imageName: "today_icon"),
        createNavController(viewController:AppsSearchController() , title: "Search", imageName: "search")
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
