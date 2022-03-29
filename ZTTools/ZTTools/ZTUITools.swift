//
//  ZTViewTools.swift
//  XHSG
//
//  Created by Asuna on 2020/7/10.
//  Copyright © 2020 Asuna. All rights reserved.
//

import UIKit

public final class ZTUITools {

    /// 获取屏幕的高度（做了来电处理）
    public class func screenHeight() -> CGFloat {
        if UIApplication.shared.statusBarFrame.size.height == 40 {
            return UIScreen.main.bounds.size.height - 20
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    /// 获取当前显示的控制器，包含模态出来的（适用于能获取当前显示的View的情况下）
    public class func getCurrentVCForView(view: UIView) -> UIViewController? {
        let next = view.superview
        if next != nil {
            if let nextResponder = next!.next {
                if nextResponder.isKind(of: UIViewController.self) {
                    return (nextResponder as! UIViewController)
                } else {
                    return self.getCurrentVCForView(view: next!)
                }
            } else {
                return self.getCurrentVCForView(view: next!)
            }
        }
        
        return nil
    }
    
    /// 获取当前显示的控制器，包含模态出来的（适用于当前类是NSObject，并且不能根据根控制器的情况下）
    public class func getCurrentVCForWindow() -> UIViewController? {
        guard let window = ZTDeviceManager.getKeyWindow() else {
            return nil
        }
        
        let lastView = window.getLastView()
        return self.getCurrentVCForView(view: lastView)!
    }
    
    /// 获取当前屏幕显示的控制器，包含模态出来的(适用于可以根据根控制器来获取的情况下，如果是自定义的TabBar就不行了)
    public class func getVisibleVC() -> UIViewController? {
        guard let window = ZTDeviceManager.getKeyWindow() else {
            return nil
        }
        
        let root = window.rootViewController!
        return self.getVisibleViewController(rootVC: root)
    }
    
    private class func getVisibleViewController(rootVC: UIViewController) -> UIViewController {
        var currentVC: UIViewController! = nil
        var temp = rootVC
        
        if rootVC.parent != nil {
            temp = rootVC.parent!
        }
        
        if temp.isKind(of: UITabBarController.self) {
            currentVC = self.getVisibleViewController(rootVC: (temp as! UITabBarController).selectedViewController!)
        } else if temp.isKind(of: UINavigationController.self) {
            currentVC = self.getVisibleViewController(rootVC: (temp as! UINavigationController).visibleViewController!)
        } else {
            currentVC = temp
        }
        
        return currentVC
    }
    
    /// 获取当前屏幕显示的控制器，不包含模态出来的(适用于可以根据根控制器来获取的情况下，如果是自定义的TabBar就不行了)
    public class func getCurrentVC() -> UIViewController? {
        guard let window = ZTDeviceManager.getKeyWindow() else {
            return nil
        }
        
        let root = window.rootViewController!
        return self.getCurrentViewController(rootVC: root)
    }
    
    private class func getCurrentViewController(rootVC: UIViewController) -> UIViewController {
        var currentVC: UIViewController! = nil
        var temp = rootVC
        
        if rootVC.parent != nil {
            temp = rootVC.parent!
        }
        
        if temp.isKind(of: UITabBarController.self) {
            currentVC = self.getCurrentViewController(rootVC: (temp as! UITabBarController).selectedViewController!)
        } else if temp.isKind(of: UINavigationController.self) {
            currentVC = self.getCurrentViewController(rootVC: (temp as! UINavigationController).topViewController!)
        } else {
            currentVC = temp
        }
        
        return currentVC
    }
    
    /// 获取当前屏幕显示的导航控制器，包含模态出来的(适用于可以根据根控制器来获取的情况下，如果是自定义的TabBar就不行了)
    public class func getVisibleNC() -> UINavigationController? {
        guard let window = ZTDeviceManager.getKeyWindow() else {
            return nil
        }
        
        let root = window.rootViewController!
        return self.getVisibleNavigationController(rootVC: root) as? UINavigationController
    }
    
    private class func getVisibleNavigationController(rootVC: UIViewController) -> UIViewController {
        var currentVC: UIViewController! = nil
        var temp = rootVC
        
        if rootVC.parent != nil {
            temp = rootVC.parent!
        }
        
        if temp.isKind(of: UITabBarController.self) {
            currentVC = self.getVisibleViewController(rootVC: (temp as! UITabBarController).selectedViewController!)
        } else if temp.isKind(of: UINavigationController.self) {
            currentVC = self.getVisibleViewController(rootVC: (temp as! UINavigationController).visibleViewController!)
        } else {
            currentVC = temp.navigationController
        }
        
        return currentVC
    }
    
    /// 获取当前屏幕显示的导航控制器，不包含模态出来的(适用于可以根据根控制器来获取的情况下，如果是自定义的TabBar就不行了)
    public class func getCurrentNC() -> UINavigationController? {
        guard let window = ZTDeviceManager.getKeyWindow() else {
            return nil
        }
        
        let root = window.rootViewController!
        return self.getCurrentNavigationController(rootVC: root) as? UINavigationController
    }
    
    private class func getCurrentNavigationController(rootVC: UIViewController) -> UIViewController {
        var currentVC: UIViewController! = nil
        var temp = rootVC
        
        if rootVC.parent != nil {
            temp = rootVC.parent!
        }
        
        if temp.isKind(of: UITabBarController.self) {
            currentVC = self.getCurrentViewController(rootVC: (temp as! UITabBarController).selectedViewController!)
        } else if temp.isKind(of: UINavigationController.self) {
            currentVC = self.getCurrentViewController(rootVC: (temp as! UINavigationController).topViewController!)
        } else {
            currentVC = temp.navigationController
        }
        
        return currentVC
    }
}
