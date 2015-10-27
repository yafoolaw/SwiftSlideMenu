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
    
    public static var pointOfNoReturnWidth:       CGFloat = 44.0
    
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
        addLeftGesture()
        
        addRightGesture()
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        
        leftContainerView.hidden = true
        
        rightContainerView.hidden = true
        
        coordinator.animateAlongsideTransition(nil) { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            
            self.closeLeftNonAnimation()
            
            self.closeRightNonAnimation()
            
            self.leftContainerView.hidden = false
            
            self.rightContainerView.hidden = false
            
            if self.leftPanGesture != nil {
            
                self.removeLeftGesture()
                self.addLeftGesture()
            }
            
            if self.rightPanGesture != nil {
            
                self.removeRightGesture()
                self.addRightGesture()
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
    }
    
    public override func viewWillLayoutSubviews() {
        
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        setUpViewController(leftContainerView, targetViewController: leftViewController)
        setUpViewController(rightContainerView, targetViewController: rightViewController)
    }
    
    public override func openLeft() {
    
        setOpenWindowLevel()
        
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        
        openLeftWithVelocity(0)
        
        track(.TapOpen)
    }
    
    
    public override func openRight() {
        
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        
        openRightWithVelocity(0)
    }
    
    public override func closeLeft() {
        
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        
        closeLeftWithVelocity(0)
        
        setCloseWindowLevel()
    }
    
    public override func closeRight() {
        
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        
        closeRightWithVelocity(0)
        
        setCloseWindowLevel()
    }
    
    
    // MARK: 手势相关方法
    public func addLeftGesture() {
    
        if leftViewController != nil {
        
            if leftPanGesture == nil {
            
                leftPanGesture = UIPanGestureRecognizer(target: self, action: "handleLeftPanGesture:")
                leftPanGesture?.delegate = self;
                view.addGestureRecognizer(leftPanGesture!)
            }
            
            if leftTapGesture == nil {
            
                leftTapGesture = UITapGestureRecognizer(target: self, action: "toggleLeft")
                leftTapGesture?.delegate = self
                view.addGestureRecognizer(leftTapGesture!)
            }
        }
    }
    
    public func addRightGesture() {
    
        if rightViewController != nil {
        
            if rightPanGesture == nil {
            
                rightPanGesture = UIPanGestureRecognizer(target: self, action: "handleRightGesture:")
                rightPanGesture?.delegate = self
                view.addGestureRecognizer(rightPanGesture!)
            }
            
            if rightTapGesture == nil {
            
                rightTapGesture = UITapGestureRecognizer(target: self, action: "toggleRight")
                rightTapGesture?.delegate = self
                view.addGestureRecognizer(rightTapGesture!)
            }
        }
    }
    
    public func removeLeftGesture() {
    
        if leftPanGesture != nil {
        
            view.removeGestureRecognizer(leftPanGesture!)
            leftPanGesture = nil
        }
        
        if leftTapGesture != nil {
        
            view.removeGestureRecognizer(leftTapGesture!)
            leftTapGesture = nil
        }
    }
    
    public func removeRightGesture() {
    
        if rightPanGesture != nil {
        
            view.removeGestureRecognizer(rightPanGesture!)
            rightPanGesture = nil
        }
        
        if rightTapGesture != nil {
        
            view.removeGestureRecognizer(rightTapGesture!)
            rightTapGesture = nil
        }
    }
    
    public func isTargetViewController() -> Bool {
    
        // Function to determine the target ViewController
        // Please to override it if necessary
        return true
    }
    
    public func track(trackAction: TrackAction) {
    
        // function is for tracking
        // Please to override it if necessary
    }
    
    struct LeftPanState {
        
        static var frameAtStartOfPan:     CGRect  = CGRectZero
        
        static var startPointOfPan:       CGPoint = CGPointZero
        
        static var wasOpenAtStartOfPan:   Bool    = false
        
        static var wasHiddenAtStartOfPan: Bool    = false
    }
    
    struct RightPanState {
        
        static var frameAtStartOfPan:     CGRect  = CGRectZero
        
        static var startPointOfPan:       CGPoint = CGPointZero
        
        static var wasOpenAtStartOfPan:   Bool    = false
        
        static var wasHiddenAtStartOfPan: Bool    = false
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
    
        if isTargetViewController() == false {
        
            return
        }
        
        if isRightOpen() {
        
            return
        }
        
        switch panGesture.state {
        
        case UIGestureRecognizerState.Began:
            
            LeftPanState.frameAtStartOfPan     = leftContainerView.frame
            LeftPanState.startPointOfPan       = panGesture.locationInView(view)
            LeftPanState.wasHiddenAtStartOfPan = isLeftHidden()
            LeftPanState.wasOpenAtStartOfPan   = isLeftOpen()
            
            leftViewController?.beginAppearanceTransition(LeftPanState.wasHiddenAtStartOfPan, animated: true)
            
            addShadowToView(leftContainerView)
            
            setOpenWindowLevel()
            
        case UIGestureRecognizerState.Changed:
            
            let transaltion: CGPoint = panGesture.translationInView(panGesture.view!)
            
            leftContainerView.frame  = applyLeftTranslation(transaltion, toFrame: LeftPanState.frameAtStartOfPan)
            
            applyLeftOpacity()
            
            applyLeftContentViewScale()
            
        case UIGestureRecognizerState.Ended:
            
            let velocity: CGPoint = panGesture.velocityInView(panGesture.view)
            
            let panInfo: PanInfo  = panLeftResultInfoForVelocity(velocity)
            
            if panInfo.action == .Open {
            
                if LeftPanState.wasHiddenAtStartOfPan == false {
                
                    leftViewController?.beginAppearanceTransition(true, animated: true)
                }
                
                openLeftWithVelocity(panInfo.velocity)
                
                track(.FlickOpen)
            } else {
            
                if LeftPanState.wasHiddenAtStartOfPan {
                
                    leftViewController?.beginAppearanceTransition(false, animated: true)
                }
                
                closeLeftWithVelocity(panInfo.velocity)
                
                setCloseWindowLevel()
                
                track(.FlickClose)
                
            }
            
            
        default:
            
            break
        }
    }
    
    func handleRightPanGesture(panGesture: UIPanGestureRecognizer) {
    
        if isTargetViewController() == false {
        
            return
        }
        
        if isLeftOpen() {
        
            return
        }
        
        switch panGesture.state {
        
        case UIGestureRecognizerState.Began:
            
            RightPanState.frameAtStartOfPan = rightContainerView.frame
            RightPanState.startPointOfPan   = panGesture.locationInView(view)
            RightPanState.wasOpenAtStartOfPan = isRightOpen()
            RightPanState.wasHiddenAtStartOfPan = isRightHidden()
            
            rightViewController?.beginAppearanceTransition(RightPanState.wasHiddenAtStartOfPan, animated: true)
            
            addShadowToView(rightContainerView)
            
            setOpenWindowLevel()
            
            
            
        case UIGestureRecognizerState.Changed:
            
            let translation: CGPoint = panGesture.translationInView(panGesture.view!)
            
            rightContainerView.frame = applyRightTranslation(translation, toFrame: RightPanState.frameAtStartOfPan)
            
            applyRightOpacity()
            
            applyRightContentViewScale()
            
            
            
        case UIGestureRecognizerState.Ended:
            
            let velocity: CGPoint = panGesture.velocityInView(panGesture.view)
            
            let panInfo: PanInfo = panRightResultInfoForVelocity(velocity)
            
            if panInfo.action == .Open {
            
                if RightPanState.wasHiddenAtStartOfPan == false {
                
                    rightViewController?.beginAppearanceTransition(true, animated: true)
                }
                
                openRightWithVelocity(panInfo.velocity)
                
            } else {
            
                if RightPanState.wasHiddenAtStartOfPan {
                
                    rightViewController?.beginAppearanceTransition(false, animated: true)
                }
                
                closeRightWithVelocity(panInfo.velocity)
                setCloseWindowLevel()
            }
            
            
            
        default: break
        }
    }
    
    public func openLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin:      CGFloat = leftContainerView.frame.origin.x
        
        let finalXOrigin: CGFloat = 0
        
        var frame = leftContainerView.frame
        
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        addShadowToView(leftContainerView)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.leftContainerView.frame     = frame
                
                strongSelf.opacityView.layer.opacity   = Float(SlideMenuOptions.contentViewOpacity)
                
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(SlideMenuOptions.contentViewScale, SlideMenuOptions.contentViewScale)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                
                    strongSelf.disableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
                
        }
    }
    
    public func openRightWithVelocity(velocity: CGFloat) {
    
        let xOrigin:      CGFloat = rightContainerView.frame.origin.x
        
        let finalXOrigin: CGFloat = 0
        
        var frame = rightContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - CGRectGetWidth(view.bounds)) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        addShadowToView(rightContainerView)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.rightContainerView.frame    = frame
                strongSelf.opacityView.layer.opacity   = Float(SlideMenuOptions.contentViewOpacity)
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(SlideMenuOptions.contentViewScale, SlideMenuOptions.contentViewScale)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                
                    strongSelf.disableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
        }
    }
    
    public func closeLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin:      CGFloat = leftContainerView.frame.origin.x
        
        let finalXOrigin: CGFloat = leftMinOrigin()
        
        var frame: CGRect = leftContainerView.frame
        frame.origin.x    = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
                
                strongSelf.leftContainerView.frame     = frame
                strongSelf.opacityView.layer.opacity   = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                    
                    strongSelf.removeShadow(strongSelf.leftContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
        }
        
    }
    
    public func closeRightWithVelocity(velocity: CGFloat) {
    
        let xOrigin:      CGFloat = rightContainerView.frame.origin.x
        
        let finalXOrigin: CGFloat = CGRectGetWidth(view.bounds)
        
        var frame: CGRect = rightContainerView.frame
        frame.origin.x    = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
            
            duration = Double(fabs(xOrigin - CGRectGetWidth(view.bounds)) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
                
                strongSelf.rightContainerView.frame    = frame
                strongSelf.opacityView.layer.opacity   = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                    strongSelf.removeShadow(strongSelf.rightContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
        }
    }
    
    public override func toggleLeft() {
    
        if isLeftOpen() {
        
            closeLeft()
            
            setCloseWindowLevel()
            
            track(.TapClose)
            
        } else {
        
            openLeft()
        }
    }
    
    public func isLeftOpen() -> Bool {
    
        return leftContainerView.frame.origin.x == 0
    }
    
    public func isLeftHidden() -> Bool {
    
        return leftContainerView.frame.origin.x <= leftMinOrigin()
    }
    
    public override func toggleRight() {
        
        if isRightOpen() {
        
            closeRight()
            
            setCloseWindowLevel()
            
        } else {
        
            openRight()
        }
    }
    
    public func isRightOpen() -> Bool {
    
        return rightContainerView.frame.origin.x == CGRectGetWidth(view.bounds) - rightContainerView.frame.size.width
    }
    
    public func isRightHidden() -> Bool {
    
        return rightContainerView.frame.origin.x >= CGRectGetWidth(view.bounds)
    }
    
    public func changeMainViewController(mainViewController: UIViewController, close: Bool) {
    
        removeViewController(self.mainViewController)
        
        self.mainViewController = mainViewController
        
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        
        if close {
        
            closeLeft()
            closeRight()
        }
        
    }
    
    public func changeLeftViewController(leftViewController: UIViewController, closeLeft: Bool) {
    
        removeViewController(self.leftViewController)
        
        self.leftViewController = leftViewController
        
        setUpViewController(leftContainerView, targetViewController: leftViewController)
        
        if closeLeft {
        
            self.closeLeft()
        }
    }
    
    public func changeRightViewController(rightViewController: UIViewController, closeRight: Bool) {
    
        removeViewController(self.rightViewController)
        
        self.rightViewController = rightViewController
        
        setUpViewController(rightContainerView, targetViewController: rightViewController)
        
        if closeRight {
        
            self.closeRight()
        }
    }
    
    private func leftMinOrigin() -> CGFloat {
    
        return -SlideMenuOptions.leftViewWidth
    }
    
    private func rightMinOrigin() -> CGFloat {
    
        return CGRectGetWidth(view.frame)
    }
    
    private func panLeftResultInfoForVelocity(velocity: CGPoint) -> PanInfo {
    
        let thresholdVelocity: CGFloat = 1000.0
        
        let pointOfNoReturn: CGFloat = CGFloat(floor(leftMinOrigin())) + SlideMenuOptions.pointOfNoReturnWidth
        
        let leftOrigin: CGFloat = leftContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .Close, shouldBounce: false, velocity: 0)
        
        panInfo.action = leftOrigin <= pointOfNoReturn ? .Close : .Open
        
        if velocity.x >= thresholdVelocity {
        
            panInfo.action = .Open
            
            panInfo.velocity = velocity.x
            
        } else if velocity.x <= -thresholdVelocity {
        
            panInfo.action = .Close
            
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    private func panRightResultInfoForVelocity(velocity: CGPoint) -> PanInfo {
    
        let thresholdVelocity: CGFloat = -1000.0
        
        let pointOfNoReturn: CGFloat = CGFloat(floor(CGRectGetWidth(view.bounds)) - SlideMenuOptions.pointOfNoReturnWidth)
        
        let rightOrigin: CGFloat = rightContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .Close, shouldBounce: false, velocity: 0)
        
        panInfo.action = rightOrigin >= pointOfNoReturn ? .Close : .Open
        
        if velocity.x <= thresholdVelocity {
        
            panInfo.action = .Open
            
            panInfo.velocity = velocity.x
            
        } else if velocity.x >= -thresholdVelocity {
        
            panInfo.action = .Close
            
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    private func getOpenedLeftRatio() -> CGFloat {
    
        let width: CGFloat = leftContainerView.frame.size.width
        
        let currentPosition: CGFloat = leftContainerView.frame.origin.x - leftMinOrigin()

        return currentPosition / width
    }
    
    private func getOpenedRightRatio() -> CGFloat {
    
        let width: CGFloat = rightContainerView.frame.size.width
        
        let currentPosition:CGFloat = rightContainerView.frame.origin.x
        
        return -(currentPosition - CGRectGetWidth(view.bounds)) / width
    }
    
    private func applyLeftOpacity() {
    
        let openedLeftRatio: CGFloat = getOpenedLeftRatio()
        
        let opacity: CGFloat = SlideMenuOptions.contentViewOpacity * openedLeftRatio
        
        opacityView.layer.opacity = Float(opacity)
    }
    
    private func applyRightOpacity() {
    
        let openedRightRatio: CGFloat = getOpenedRightRatio()
        
        let opacity: CGFloat = SlideMenuOptions.contentViewOpacity * openedRightRatio
        
        opacityView.layer.opacity = Float(opacity)
    }
    
    private func applyLeftContentViewScale() {
    
        let openedLeftRation: CGFloat = getOpenedLeftRatio()
        
        let scale: CGFloat = 1.0 - (1.0 - SlideMenuOptions.contentViewScale) * openedLeftRation
        
        mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    private func applyRightContentViewScale() {
    
        let openedRightRatio: CGFloat = getOpenedRightRatio()
        
        let scale: CGFloat = 1.0 - (1.0 - SlideMenuOptions.contentViewScale) * openedRightRatio
        
        mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    private func addShadowToView(targetContainerView: UIView) {
        
        targetContainerView.layer.masksToBounds = false
        targetContainerView.layer.shadowOffset  = SlideMenuOptions.shadowOffset
        targetContainerView.layer.shadowOpacity = Float(SlideMenuOptions.shadowOpacity)
        targetContainerView.layer.shadowRadius  = SlideMenuOptions.shadowRadius
        targetContainerView.layer.shadowPath    = UIBezierPath(rect: targetContainerView.bounds).CGPath
    }
    
    private func removeShadow(targetContainerView: UIView) {
    
        targetContainerView.layer.masksToBounds = true
        
        mainContainerView.layer.opacity = 1.0
    }
    
    private func disableContentInteraction() {
    
        mainContainerView.userInteractionEnabled = false
    }
    
    private func enableContentInteraction() {
    
        mainContainerView.userInteractionEnabled = true
    }
    
    private func setOpenWindowLevel() {
        
        if SlideMenuOptions.hideStatusBar {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let window = UIApplication.sharedApplication().keyWindow {
                
                    window.windowLevel = UIWindowLevelStatusBar + 1
                }
            })
        }
    
    }
    
    private func setCloseWindowLevel() {
    
        if SlideMenuOptions.hideStatusBar {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let window = UIApplication.sharedApplication().keyWindow {
                
                    window.windowLevel = UIWindowLevelNormal
                }
            })
        }
    }
    
    private func setUpViewController(targetView: UIView, targetViewController: UIViewController?) {
    
        if let viewController = targetViewController {
        
            addChildViewController(viewController)
            
            viewController.view.frame = targetView.bounds
            
            targetView.addSubview(viewController.view)
            
            viewController.didMoveToParentViewController(self)
            
        }
    }
    
    private func removeViewController(viewController: UIViewController?) {
    
        if let _viewController = viewController {
        
            _viewController.willMoveToParentViewController(nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    public func closeLeftNonAnimation() {
        
        setCloseWindowLevel()
        
        //        let finalXOrigin: CGFloat = leftMinOrigin()
        //
        //        var frame: CGRect = leftContainerView.frame
        //
        //        frame.origin.x = finalXOrigin
        //
        //        leftContainerView.frame = frame
        
        leftContainerView.frame.origin.x = leftMinOrigin()
        
        opacityView.layer.opacity = 0
        
        mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        
        removeShadow(leftContainerView)
        
        enableContentInteraction()
    }
    
    public func closeRightNonAnimation() {
        
        setCloseWindowLevel()
        
        rightContainerView.frame.origin.x = CGRectGetWidth(view.bounds)
        
        opacityView.layer.opacity = 0
        
        mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        
        removeShadow(rightContainerView)
        
        enableContentInteraction()
    }
    
    private func applyLeftTranslation(translation: CGPoint, toFrame: CGRect) -> CGRect {
    
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        let minOrigin: CGFloat = leftMinOrigin()
        let maxOrigin: CGFloat = 0
        var newFrame: CGRect   = toFrame
        
        if newOrigin < minOrigin {
        
            newOrigin = minOrigin
            
        } else if newOrigin > maxOrigin {
        
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        
        return newFrame
    }
    
    private func applyRightTranslation(translation: CGPoint, toFrame: CGRect) -> CGRect {
    
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        let minOrigin: CGFloat = rightMinOrigin()
        let maxOrigin: CGFloat = rightMinOrigin() - rightContainerView.frame.size.width
        
        var newFrame: CGRect = toFrame
        
        if newOrigin > minOrigin {
        
            newOrigin = minOrigin
            
        } else if newOrigin < maxOrigin {
        
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        
        return newFrame
    }

}



extension UIViewController {

    public func slideMenuController() -> SlideMenuController? {
    
        var viewController: UIViewController? = self
        
        while viewController != nil {
        
            if viewController is SlideMenuController {
            
                return viewController as? SlideMenuController
            }
            
            viewController = viewController?.parentViewController
        }
        
        return nil
    }
    
    public func addLeftBarButtonWithImage(buttonImage: UIImage) {
    
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: .Plain, target: self, action: "toggleLeft")
        
        navigationItem.leftBarButtonItem = leftButton
    }
    
    public func addRightButtonWithImage(buttonImage: UIImage) {
    
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: .Plain, target: self, action: "toggleRight")
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    public func toggleLeft() {
    
        slideMenuController()?.toggleLeft()
    }
    
    public func toggleRight() {
    
        slideMenuController()?.toggleRight()
    }
    
    public func openLeft() {
    
        slideMenuController()?.openLeft()
    }
    
    public func openRight() {
    
        slideMenuController()?.openRight()
    }
    
    public func closeLeft() {
    
        slideMenuController()?.closeLeft()
    }
    
    public func closeRight() {
    
        slideMenuController()?.closeRight()
    }
    
    public func addPriorityToMenuGesture(targetScrollView: UIScrollView) {
    
        guard let slideController = slideMenuController(), let recognizers = slideController.view.gestureRecognizers else {
        
            return
        }
        
        for recongizer in recognizers where recongizer is UIPanGestureRecognizer {
        
            targetScrollView.panGestureRecognizer.requireGestureRecognizerToFail(recongizer)
        }
    }
}