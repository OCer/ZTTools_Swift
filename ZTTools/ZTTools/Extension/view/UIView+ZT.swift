//
//  UIView+ZT.swift
//  ZTToosSDK
//
//  Created by Asuna on 2022/3/1.
//

import UIKit

public extension UIView {
    
    /// 获取view的最后一个子view，如果没有就是它本身
    func getLastView() -> UIView {
        var lastView = self
        
        if self.subviews.count > 0 {
            lastView = self.subviews.last!.getLastView()
        }
        
        return lastView
    }
    
    /// 删除view的所有子view
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
