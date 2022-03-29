//
//  ZTLanguageManager.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation

public enum ZTLanguageType: Int {
    case system = 0, cn, en
}

private let kUserLanguage = "ZTUserLanguage" // 用户设置的语言

public final class ZTLanguageManager {
    
    private var type: ZTLanguageType = .system
    
    private var bundle: Bundle = Bundle.main
    
    public static let sharedManager = ZTLanguageManager()
    
    /// 获取当前设置语言的下标
    public var index: Int {
        get {
            return type.rawValue
//            switch type {
//                case .system:
//                    return 0
//
//                case .cn:
//                    return 1
//
//                case .en:
//                    return 2
//            }
        }
    }
    
    private init() {
        let language = getCurrentLanguageCode() // 获取用户设置的语言
        
        if type != .system {
            let path = Bundle.main.path(forResource: language, ofType: "lproj")
            bundle = Bundle(path: path!)!
        }
    }
    
    /// 获取当前设置的语言代码
    public func getCurrentLanguageCode() -> String {
        var language = UserDefaults.standard.object(forKey: kUserLanguage) as? String
        
        if (language?.count ?? 0) == 0 {
            type = .system
            language = ZTLanguageManager.getPreferredLanguage()
        } else if language!.hasPrefix("zh-Hans") {
            type = .cn
        } else {
            type = .en
        }
        
        return language!
    }
    
    /// 获取当前语言的名称
    public func getCurrentLanguageName() -> String {
        var code = "default"
        
        switch type {
            case .cn:
                code = "chinese"
            
            case .en:
                code = "english"
            
            default: break
        }
        
        return localizedStringForKey(key: code)
    }
    
    /// 设置语言
    public func updateLanguageWithType(_ type: ZTLanguageType) {
        self.type = type
        
        if type == .system {
            bundle = Bundle.main
            UserDefaults.standard.removeObject(forKey: kUserLanguage)
        } else {
            let language = ZTLanguageManager.languageTypeToString(type: type)
            let path = Bundle.main.path(forResource: language, ofType: "lproj")
            bundle = Bundle(path: path!)!
            UserDefaults.standard.set(language, forKey: kUserLanguage)
        }
        
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(kNotificationWithChangeLanguage), object: nil) // 发出切换语言的通知
    }
    
    /// 获取国际化字符串
    public func localizedStringForKey(key: String, value: String? = nil, table: String? = nil) -> String {
        return bundle.localizedString(forKey: key, value: value, table: table)
    }
    
    /// 语言枚举转字符串
    public class func languageTypeToString(type: ZTLanguageType) -> String {
        switch type {
            case .cn:
                return "zh-Hans"
            
            case .en:
                return "en"
            
            default: break
        }
        
        return getPreferredLanguage()
    }
    
    /// 获取系统的当前语言code标识
    public class func getPreferredLanguage() -> String {
        let defaults = UserDefaults.standard
        let allLanguages = defaults.object(forKey: "AppleLanguages") as! [String]
        let preferredLang = allLanguages.first!
        var localeLanguageCode = NSLocale.current.regionCode! // 地区编码

        localeLanguageCode = "-" + localeLanguageCode
        if preferredLang.hasSuffix(localeLanguageCode) {
            let code = preferredLang.substingInRange(0 ..< preferredLang.count - localeLanguageCode.count)!
            
            return code
        }
        
        return preferredLang
    }
}
