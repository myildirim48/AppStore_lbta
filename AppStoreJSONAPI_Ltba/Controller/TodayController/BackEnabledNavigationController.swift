//
//  BackEnabledNavigationController.swift
//  AppStoreJSONAPI_Ltba
//
//  Created by YILDIRIM on 26.12.2022.
//

import UIKit

class BackEnabledNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
