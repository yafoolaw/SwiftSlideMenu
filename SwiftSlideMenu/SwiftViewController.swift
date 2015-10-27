//
//  SwiftViewController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.grayColor()
        
        let label = UILabel(frame: CGRectMake(0, 100, 200, 60))
        
        label.center.x = view.center.x
        
        label.text = "SwiftViewController"
        
        view.addSubview(label)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
