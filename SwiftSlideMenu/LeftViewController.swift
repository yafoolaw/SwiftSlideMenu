//
//  LeftViewController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

enum LeftMenu: Int {

    case Main = 0
    case Swift
    case Java
    case Go
    case NonMenu
}

protocol LeftMenuProtocol : class {

    func changeViewController(menu: LeftMenu)
}

class LeftViewController: UIViewController, LeftMenuProtocol, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var menus = ["Main", "Swift", "Java", "Go", "NonMenu"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var javaViewController:  UIViewController!
    var goViewController:    UIViewController!
    var nonMenuViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorColor = UIColor.brownColor()
        tableView.registerCellClass(BaseTableViewCell.self)
        view.addSubview(tableView)
        
        swiftViewController        = UINavigationController(rootViewController: SwiftViewController())
        
        javaViewController         = UINavigationController(rootViewController: JavaViewController())
        
        goViewController           = UINavigationController(rootViewController: GoViewController())
        
        let nonMenuViewController = NonMenuController()
        nonMenuViewController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuViewController)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: BaseTableViewCell = BaseTableViewCell(style: .Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        
        cell.backgroundColor = UIColor.purpleColor()
        
        cell.textLabel?.font      = UIFont.italicSystemFontOfSize(18)
        cell.textLabel?.textColor = UIColor.grayColor()
        cell.textLabel?.text      = menus[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
        
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: LeftMenu) {
        
        switch menu {
        
        case .Main:
            
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            
        case .Swift:
            
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
            
        case .Java:
            
            self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
            
        case .Go:
            
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
            
        case .NonMenu:
            
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        }
    }

}
