//
//  UITableViewExtension.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/21.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

public extension UITableView {

    func registerCellClass(cellClass: AnyClass) {
    
        let identifier = String.className(cellClass)
        
        self.registerClass(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass) {
    
        let identifier = String.className(cellClass)
        
        let nib = UINib(nibName: identifier, bundle: nil)
        
        self.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(viewClass: AnyClass) {
    
        let identifier = String.className(viewClass)
        
        self.registerClass(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(cellClass: AnyClass) {
    
        let identifier = String.className(cellClass)
        
        let nib = UINib(nibName: identifier, bundle: nil)
        
        self.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
