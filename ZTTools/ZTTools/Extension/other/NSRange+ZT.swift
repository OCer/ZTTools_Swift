//
//  NSRange+ZT.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation

public extension NSRange {
    
    /// NSRange转Range
    func toRange(_ range: NSRange, text: String) -> Range<String.Index> {
        return Range(range, in: text)!
    }
    
    /// Range转NSRange
    func toRange(_ range: NSRange) -> Range<Int> {
        return Range(range)!
    }
}
