//
//  SlideMenuController.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/21.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

public struct SlideMenuOptions {

    public static var leftViewWidth:              CGFloat = 270.0
    
    public static var leftBezelWidth:             CGFloat = 16.0
    
    public static var contentViewScale:           CGFloat = 0.96
    
    public static var contentViewOpacity:         CGFloat = 0.5
    
    public static var shadowOpacity:              CGFloat = 0
    
    public static var shadowRadius:               CGFloat = 0
    
    public static var shadowOffset:               CGSize  = CGSizeZero
    
    public static var panFromBezel:               Bool    = true
    
    public static var animationDuration:          CGFloat = 0.4
    
    public static var rightViewWidth:             CGFloat = 270.0
    
    public static var rightBezelWidth:            CGFloat = 16.0
    
    public static var rightPanFromBezel:          Bool    = true
    
    public static var hideStatusBar:              Bool    = true
    
    public static var pointOfNoReturnBar:         CGFloat = 44.0
    
    public static var opacityViewBackgroundColor: UIColor = UIColor.blackColor()
}



public class SlideMenuController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: 变量
    public enum SlideAction {
    
        case Open
        
        case Close
    }
    
    public enum TrackAction {
    
        case TapOpen
        
        case TapClose
        
        case FlickOpen
        
        case FlickClose
    }
    
    struct PanInfo {
        
        var action:       SlideAction
        
        var shouldBounce: Bool
        
        var velocity:     CGFloat
    }
    
    public var opacityView        = UIView()
    
    public var mainContainerView  = UIView()
    
    public var leftContainerView  = UIView()
    
    public var rightContainerView = UIView()
    
    public var mainViewController:  UIViewController?
    
    public var leftViewController:  UIViewController?
    
    public var leftPanGesture:      UIPanGestureRecognizer?
    
    public var leftTapGesture:      UITapGestureRecognizer?
    
    public var rightViewController: UIViewController?
    
    public var rightPanGesture:     UIPanGestureRecognizer?
    
    public var rightTapGesture:     UITapGestureRecognizer?
    
    // MARK: 初始化方法
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
    
        self.init()
        
        self.mainViewController = mainViewController
        
        leftViewController      = leftMenuViewController
        
        initView()
    }
    
    public convenience init(mainViewController: UIViewController, rightMenuViewController: UIViewController) {
    
        self.init()
        
        self.mainViewController = mainViewController
        
        rightViewController     = rightMenuViewController
        
        initView()
    }
    
    public convenience init(mainViewController: UIViewController,
                        leftMenuViewController: UIViewController,
                       rightMenuViewController: UIViewController) {
    
        self.init()
        
        self.mainViewController = mainViewController
        
        leftViewController      = leftMenuViewController
        
        rightViewController     = rightMenuViewController
        
        initView()
    }
    
    deinit {}
    
    func initView() {
    
        // mainContainerView
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.backgroundColor  = UIColor.clearColor()
        mainContainerView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        view.insertSubview(mainContainerView, atIndex: 0)
        
        // opacityView
        let opacityOffset: CGFloat = 0
        
        var opacityFrame: CGRect = view.bounds
        opacityFrame.origin.y    += opacityOffset
        opacityFrame.size.height -= opacityOffset
        
        opacityView = UIView(frame: opacityFrame)
        opacityView.backgroundColor  = SlideMenuOptions.opacityViewBackgroundColor
        opacityView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        opacityView.layer.opacity    = 0
        view.insertSubview(opacityView, atIndex: 1)
        
        // leftContainerView
        let leftOffset: CGFloat = 0
        
        var leftFrame: CGRect = view.bounds
        leftFrame.size.width  =  SlideMenuOptions.leftViewWidth
        leftFrame.origin.x    =  leftMinOrigin()
        leftFrame.origin.y    += leftOffset
        leftFrame.size.height -= leftOffset
        
        leftContainerView = UIView(frame: leftFrame)
        leftContainerView.backgroundColor  = UIColor.clearColor()
        leftContainerView.autoresizingMask = .FlexibleHeight
        view.insertSubview(leftContainerView, atIndex: 2)
        
        // rightContainerView
        let rightOffset: CGFloat = 0
        
        var rightFrame: CGRect =  view.bounds
        rightFrame.size.width  =  SlideMenuOptions.rightViewWidth
        rightFrame.origin.x    =  rightMinOrigin()
        rightFrame.origin.y    += rightOffset
        rightFrame.size.height -= rightOffset
        
        rightContainerView = UIView(frame: rightFrame)
        rightContainerView.backgroundColor  = UIColor.clearColor()
        rightContainerView.autoresizingMask = .FlexibleHeight
        view.insertSubview(rightContainerView, atIndex: 3)
        
        //
        
    }
    
    public func addLeftGesture() {
    
        if leftViewController != nil {
        
            if leftPanGesture == nil {
            
//                leftPanGesture = 
            }
        }
    }
    
    private func leftMinOrigin() -> CGFloat {
    
        return -SlideMenuOptions.leftViewWidth
    }
    
    private func rightMinOrigin() -> CGFloat {
    
        return CGRectGetWidth(view.frame)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
