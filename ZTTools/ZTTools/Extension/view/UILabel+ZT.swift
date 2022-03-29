//
//  UILabel+ZT.swift
//  XHSG
//
//  Created by Asuna on 2020/7/22.
//  Copyright © 2020 Asuna. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /// 添加行间距
    func addLineSpace(_ lineSpacing: CGFloat, withText text: String?) {
        if ((text?.count ?? 0) == 0) || (lineSpacing < 0.1) {
            self.text = text
            
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString = NSMutableAttributedString(string: text!)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text!.count))
        self.attributedText = attributedString
    }
}
