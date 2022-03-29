//
//  Timer+ZT.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation

public class ZTTimerBlock<T> {
    
    let type: T
    
    init(_ type: T) {
        self.type = type
    }
}

public extension Timer {
    
    /// 不需要担心循环引用的定时器
    class func zt_scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
        }
        
        return scheduledTimer(timeInterval: interval, target: self, selector: #selector(zt_handerTimerAction(_:)), userInfo: ZTTimerBlock(block), repeats: true)
    }

    @objc private class func zt_handerTimerAction(_ sender: Timer) {
        if let block = sender.userInfo as? ZTTimerBlock<(Timer) -> Void> {
            block.type(sender)
        }
    }
}
