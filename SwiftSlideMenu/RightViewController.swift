//
//  RightViewController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.backgroundColor = UIColor.redColor()
        
        let label = UILabel(frame: CGRectMake(0, 100, 200, 60))
        
        label.center.x = view.center.x
        
        label.text = "RightViewController"
        
        view.addSubview(label)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
