//
//  NonMenuController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class NonMenuController: UIViewController {

    weak var delegate: LeftMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRectMake(0, 100, 200, 60))
        
        label.center.x = view.center.x
        label.text     = "NonMenuViewController"
        
        view.addSubview(label)
        
        let button = UIButton(type: .Custom)
        
        button.frame    = CGRectMake(0, 200, 200, 60)
        button.center.x = view.center.x
        button.setTitle("ToMainViewController", forState: .Normal)
        button.addTarget(self, action: "didTouchToMain:", forControlEvents: .TouchUpInside)
        
        view.addSubview(button)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    func didTouchToMain(sender: UIButton) {
    
        delegate?.changeViewController(LeftMenu.Main)
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
