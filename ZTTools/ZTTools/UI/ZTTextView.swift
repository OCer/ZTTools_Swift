//
//  ZTTextView.swift
//  XHSG
//
//  Created by Asuna on 2019/12/14.
//  Copyright © 2019 JD. All rights reserved.
//

import UIKit

/// 去掉了除滑动外的事件，适用于可滚动的多行文本显示
open class ZTTextView: UITextView {
    
    open override var canBecomeFirstResponder: Bool {
        get {
            return false
        }
        
        set {
        }
    }
    
    /// 滑动手势
    private(set) var scrollGestureRecognizer: UIPanGestureRecognizer!

    /// 单击URL手势
    private(set) var linkGestureRecognizer: UITapGestureRecognizer!
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isEditable = false
        self.backgroundColor = .clear
        
        /*
         UITextInteractionNameSingleTap 单击
         UITextInteractionNameLinkTap   链接点击
         UITextInteractionNameDoubleTap 双击
         UITextInteractionNameTapAndAHalf 先点按之后长按
         _UIKeyboardTextSelectionGestureForcePress 长按 1
         UITextInteractionNameInteractiveLoupe     长按 2
         */
        for item in self.gestureRecognizers! {
            if item.isKind(of: UIPanGestureRecognizer.self) { // 滑动手势
                self.scrollGestureRecognizer = (item as! UIPanGestureRecognizer)
                continue
            } else if item.isMember(of: UITapGestureRecognizer.self) { // 单击URL手势
                self.linkGestureRecognizer = (item as! UITapGestureRecognizer)
                continue
            }
            
            item.isEnabled = false
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
