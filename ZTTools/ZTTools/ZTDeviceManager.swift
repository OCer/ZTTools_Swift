//
//  ZTDeviceManager.swift
//  HighWallet
//
//  Created by Asuna on 2019/12/6.
//  Copyright © 2019 JD. All rights reserved.
//

import Foundation
import UIKit
import Photos

public final class ZTDeviceManager {
    
    /// 获取iOS版本号
    public static let systemVersion: String = UIDevice.current.systemVersion
    
    /// 获取build版本
    public static let buildVersion: String = {
        let infoDictionary = Bundle.main.infoDictionary!
        
        return infoDictionary["CFBundleVersion"] as! String
    }()
    
    /// 获取APP版本号
    public static let version: String = {
        let infoDictionary = Bundle.main.infoDictionary!
        
        return infoDictionary["CFBundleShortVersionString"] as! String
    }()
    
    /// 获取Bundle ID
    public static let bundleIdentifier: String = {
        let infoDictionary = Bundle.main.infoDictionary!
        
        return infoDictionary["CFBundleIdentifier"] as! String
    }()
    
    /// 获取APP名称
    public static let appName: String = {
        var name: String = kLocalizedString(key: "CFBundleDisplayName", value: "InfoPlist")

        if name.count == 0 {
            name = kLocalizedString(key: (String)(kCFBundleNameKey), value: "InfoPlist")
        }

        return name
    }()
    
    /// 获取设备名称
    public static let platformString: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            case "iPod1,1": return "iPod Touch"
            case "iPod2,1": return "iPod Touch 2"
            case "iPod3,1": return "iPod Touch 3"
            case "iPod4,1": return "iPod Touch 4"
            case "iPod5,1": return "iPod Touch 5"
            case "iPod7,1": return "iPod Touch 6"
            case "iPod9,1": return "iPod Touch 7"
            
            case "iPhone1,1": return "iPhone"
            case "iPhone1,2": return "iPhone 3G"
            case "iPhone2,1": return "iPhone 3GS"
            case "iPhone3,1", "iPhone3,2": return "iPhone 4"
            case "iPhone3,3": return "iPhone 4 (CDMA)"
            case "iPhone4,1": return "iPhone 4S"
            case "iPhone5,1": return "iPhone 5"
            case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3": return "iPhone 5C (GSM)"
            case "iPhone5,4": return "iPhone 5C (GSM+CDMA)"
            case "iPhone6,1": return "iPhone 5S (GSM)"
            case "iPhone6,2": return "iPhone 5S (GSM+CDMA)"
            case "iPhone7,2": return "iPhone 6"
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone8,1": return "iPhone 6S"
            case "iPhone8,2": return "iPhone 6S Plus"
            case "iPhone8,4": return "iPhone SE"
            case "iPhone9,1": return "国行、日版、港行iPhone 7"
            case "iPhone9,2": return "港行、国行iPhone 7 Plus"
            case "iPhone9,3": return "美版、台版iPhone 7"
            case "iPhone9,4": return "美版、台版iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4": return "iPhone 8"
            case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6": return "iPhone X"
            case "iPhone11,8": return"iPhone XR"
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"
            case "iPhone12,8": return "iPhone SE2"
            case "iPhone13,1": return "iPhone 12 mini"
            case "iPhone13,2": return "iPhone 12"
            case "iPhone13,3": return "iPhone 12 Pro"
            case "iPhone13,4": return "iPhone 12 Pro Max"
            case "iPhone14,4": return "iPhone 13 mini"
            case "iPhone14,5": return "iPhone 13"
            case "iPhone14,2": return "iPhone 13 Pro"
            case "iPhone14,3": return "iPhone 13 Pro Max"
            case "iPhone14,6": return "iPhone SE3"
                
            case "iPad1,1": return "iPad"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
            case "iPad6,11", "iPad6,12": return "iPad 5"
            case "iPad7,5", "iPad7,6": return "iPad 6"
            case "iPad7,11", "iPad7,12": return "iPad 7"
            case "iPad11,6", "iPad11,7": return "iPad 8"
            case "iPad12,1", "iPad12,2": return "iPad 9"
            
            case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
            case "iPad5,3", "iPad5,4": return "iPad Air 2"
            case "iPad11,3", "iPad11,4": return "iPad Air 3"
            case "iPad13,1", "iPad13,2": return "iPad Air 4"
            case "iPad13,16", "iPad13,17": return "iPad Air 5"
            
            case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4": return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
            case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch)"
            case "iPad8,9", "iPad8,10": return "iPad Pro 2 (11-inch)"
            case "iPad7,1", "iPad7,2": return "iPad Pro 2 (12.9-inch)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro 3 (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 3 (12.9-inch)"
            case "iPad8,11", "iPad8,12": return "iPad Pro 4 (12.9-inch)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro 5 (12.9-inch)"
            
            case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
            case "iPad5,1", "iPad5,2": return "iPad Mini 4"
            case "iPad11,1", "iPad11,2": return "iPad Mini 5"
            case "iPad14,1", "iPad14,2": return "iPad Mini 6"
            
            case "i386", "x86_64": return "Simulator"
            case "arm64": return "Simulator M1"
            
            default: return identifier
        }
    }()
    
    private init() {
        
    }
    
    /// 获取KeyWindow
    public class func getKeyWindow() -> UIWindow? {

        // iOS13开始，使用场景来查找
        if #available(iOS 13.0, *) {
            for windowScene: UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
            }
            
            // 找不到的情况下，使用Application来查找
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    return window
                }
            }
            
            // 无法找到的情况下，就用windowSceneDelegate的window作为代替
            let windowScene: UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let windowSceneDelegate = windowScene?.delegate as? UIWindowSceneDelegate
            return windowSceneDelegate?.window ?? nil
        } else {
            if UIApplication.shared.keyWindow != nil {
                return UIApplication.shared.keyWindow!
            }
            
            // 找不到的情况下，使用Application来查找
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    return window
                }
            }
            
            // 无法找到的情况下，就用ApplicationDelegate的window作为代替
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
    
    /// 是否全面屏
    public class func isFullScreen() -> Bool {
        if #available(iOS 11.0, *) {
            if (getKeyWindow()?.safeAreaInsets.bottom ?? 0) > 0 {
                return true
            }
        }
        
        return false
    }
    
    /// 一般性震动
    public class func vibration() {
        DispatchQueue.main.async {
            let feedBackGenertor = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
            feedBackGenertor.prepare()
            feedBackGenertor.impactOccurred()
        }
    }
    
    /// Switch切换震动
    public class func vibrationWithSwitch() {
        DispatchQueue.main.async {
            let feedBackGenertor = UISelectionFeedbackGenerator()
            feedBackGenertor.prepare()
            feedBackGenertor.selectionChanged()
        }
    }
    
    /// 完成某样任务震动
    public class func vibrationWithDone(type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        DispatchQueue.main.async {
            let feedBackGenertor = UINotificationFeedbackGenerator()
            feedBackGenertor.prepare()
            feedBackGenertor.notificationOccurred(type)
        }
    }

    /// 获取总硬盘大小（单位KB）
    public class func totalDiskSpace() -> Double {
        var fattributes: [FileAttributeKey : Any]? = nil
        do {
            fattributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
        } catch {
        }
        
        return (fattributes?[.systemSize] as? NSNumber)?.doubleValue ?? 0.0
    }

    /// 获取剩余硬盘大小（单位KB）
    public class func freeDiskSpace() -> Double {
        var fattributes: [FileAttributeKey : Any]? = nil
        do {
            fattributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
        } catch {
        }
        
        return (fattributes?[.systemFreeSize] as? NSNumber)?.doubleValue ?? 0.0
    }
    
    /// 播放拍照声音
    public class func playCameraSound() {
        AudioServicesPlaySystemSound(1108)
    }
}
