//
//  ZTDarkModeManager.swift
//  DarkMode
//
//  Created by Asuna on 2022/2/22.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public typealias ZTDarkModeChangeBlock = (_ mode: UIUserInterfaceStyle) -> Void

@available(iOS 13.0, *)
public final class ZTDarkModeManager {
    
    public static let sharedManager = ZTDarkModeManager()
    
    /// 当前模式
    public lazy var currentMode: UIUserInterfaceStyle = {
        let mode = UserDefaults.standard.integer(forKey: "UIUserInterfaceStyle_currentMode")
        
        return UIUserInterfaceStyle(rawValue: mode)!
    }()
    
    private init() {
        
    }
    
    /// 设置模式
    public func setMode(mode: UIUserInterfaceStyle, _ block: ZTDarkModeChangeBlock? = nil) {
        if mode != currentMode {
            currentMode = mode
            UserDefaults.standard.set(mode.rawValue, forKey: "UIUserInterfaceStyle_currentMode")
            UserDefaults.standard.synchronize()
            
            ZTDeviceManager.getKeyWindow()?.overrideUserInterfaceStyle = mode
            
            if block != nil {
                block!(mode)
            }
        }
    }
}
