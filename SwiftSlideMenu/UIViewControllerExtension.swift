//
//  UIViewControllerExtension.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/21.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

extension UIViewController {

    func setNavigationBarItem() {
    
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.addRightButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGesture()
        self.slideMenuController()?.removeRightGesture()
        self.slideMenuController()?.addLeftGesture()
        self.slideMenuController()?.addRightGesture()
    }
    
    func removeNavigationItem() {
    
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGesture()
        self.slideMenuController()?.removeRightGesture()
    }
}
