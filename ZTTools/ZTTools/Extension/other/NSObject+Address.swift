//
//  NSObject+Address.swift
//  XHSG
//
//  Created by Asuna on 2020/6/8.
//  Copyright © 2020 JD. All rights reserved.
//

import Foundation

public extension NSObject {
    
    /// 获取对象的地址（仅限于Objective-C类）
    func objectAddress() -> String {
        return "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}
