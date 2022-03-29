//
//  ZTNetworkState.swift
//  XHSG
//
//  Created by Asuna on 2020/7/20.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation
import Alamofire

public typealias ZTNetworkStateChangeBlock = (_ state: NetworkReachabilityManager.NetworkReachabilityStatus) -> Void

public final class ZTNetworkState {

    public static let sharedNetworkState = ZTNetworkState()
    
    private let reachability: NetworkReachabilityManager? = NetworkReachabilityManager()
    
    private var dic: Dictionary<String, ZTNetworkStateChangeBlock> = Dictionary()
    
    /// 获取当前网络状态
    public var state: NetworkReachabilityManager.NetworkReachabilityStatus {
        get {
            return reachability?.status ?? .unknown
        }
    }
    
    /// 获取当前网络状态（字符串）
    public var stateString: String {
        get {
            switch state {
                case .notReachable:
                    return kLocalizedString(key: "networkDisconnected")
                
                case .reachable(NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType.cellular):
                    return kLocalizedString(key: "networkMobile")
                
                case .reachable(NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType.ethernetOrWiFi):
                    return kLocalizedString(key: "networkWIFI")
                
                default: break
            }
            
            return kLocalizedString(key: "networkUnknown")
        }
    }
    
    /// 是否连接有网络
    public var checkNetWorkIsOk: Bool {
        get {
            return reachability?.isReachable ?? true
        }
    }
    
    private init() {
        reachability?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { (state) in
            switch state {
                case .notReachable:
                    kLog("网络改变 - 没有网络")
                
                case .unknown:
                    kLog("网络改变 - 未知网络")
                
                case .reachable(NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType.cellular):
                    kLog("网络改变 - 蜂窝连接")
                
                case .reachable(NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType.ethernetOrWiFi):
                    kLog("网络改变 - WiFi")
            }
            
            let array = self.dic.values
            for block in array {
                block(state)
            }
        })
    }
    
    /// 添加网络变化回调（会强引用，需要外部自行weak）；key是唯一标识
    public func addNetworkStateChangeBlockWithKey(_ key: String, block changeBlock: @escaping ZTNetworkStateChangeBlock) -> Bool {
        if key.count == 0 {
            return false
        }
        
        self.dic.updateValue(changeBlock, forKey: key)
        
        return true
    }
    
    /// 删除网络变化回调；当需要监听的对象被销毁时，需要把block删掉
    public func removeNetworkStateChangeBlockWithKey(_ key: String) -> Bool {
        if key.count == 0 {
            return false
        }
        
        self.dic.removeValue(forKey: key)
        
        return true
    }
}
