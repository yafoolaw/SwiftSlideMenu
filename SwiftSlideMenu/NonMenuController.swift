//
//  NonMenuController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiuon 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class NonMenuController: UIViewController {

    weak var delegate: LeftMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil) { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
        
            guard let vc = (self.slideMenuController()?.mainViewController as? UINavigationController)?.topViewController else {
                return
            }
            
            if vc.isKindOfClass(NonMenuController)  {
                self.slideMenuController()?.removeLeftGesture()
                self.slideMenuController()?.removeRightGesture()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
