//
//  Constants.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//
// 全局定义

import UIKit

// 正则表达式
/// 验证邮箱
public let kRegexEmail = "^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$"

/// 验证手机号码
public let kRegexPhone = "^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9])|(198)|(199)|(166))\\d{8}$"

// 适配UI
///  屏幕高度
public let kScreenHeight = UIScreen.main.bounds.height

/// 屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.width

/// 是否是全面屏
public let kIsFullScreen = ZTDeviceManager.isFullScreen()

/// 状态栏高度
public let kZTStatusBarHeight: CGFloat = kIsFullScreen ? 44.0 : 20.0

/// 导航栏高度
public let kZTNavigationBarHeight: CGFloat = kIsFullScreen ? 88.0 : 64.0

/// tabBar高度
public let kZTTabBarHeight: CGFloat = kIsFullScreen ? 83.0 : 49.0

/// home指示器高度
public let kHomeIndicatorHeight: CGFloat = kIsFullScreen ? 34.0 : 0.0

/// 计算适配宽度
public func kAdaptW(_ floatValue: CGFloat) -> CGFloat {
    let value = kScreenWidth / 375.0 * floatValue
    return value
}

/// 计算适配高度
public func kAdaptH(_ floatValue: CGFloat) -> CGFloat {
    let value = (kIsFullScreen ? (kScreenHeight - 44 - 34) / 667.0 : kScreenHeight / 667.0) * floatValue
    return value
}

// 路径相关
/// 获取沙盒Document路径
public let kDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

/// 获取沙盒temp路径
public let kTempPath = NSTemporaryDirectory()

/// 获取沙盒Cache路径
public let kCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

// 定义相关
/// 统一起始tag
public let kTag = 10000

/// HUB统一消失时间
public let kHUBTime: Float = 1.5

/// 时间格式
public let kTimeFormate = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

/// 切换语言的通知名字
public let kNotificationWithChangeLanguage = "kZTNotificationWithChangeLanguage"

/// 增加切换语言通知的监听
public func kAddChangeLanguageNotification(observer: Any, selector: Selector) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(kNotificationWithChangeLanguage), object: nil)
}

/// 删除切换语言通知的监听
public func kRemoveChangeLanguageNotification(observer: Any) {
    NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(kNotificationWithChangeLanguage), object: nil)
}

/// 获取国际化字符串
public func kLocalizedString(key: String, value: String? = nil, table: String? = nil) -> String {
    return ZTLanguageManager.sharedManager.localizedStringForKey(key: key, value: value, table: table)
}

/// log输出
public func kLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    var i = 0
    let j = items.count
    for item in items { // items其实是个数组，直接打印会不正确
        i += 1

        // 重点:
        // 当有多个需要打印的参数时,通过三目运算符判断 终止符terminator 此时的实际值
        //   - separator: 分隔符:要在每个项目之间打印的字符串。默认值是单个空格（" "）。
        //   - terminator: 终止符:打印完所有项目后要打印的字符串。默认值是换行符 \n ("\n"）。
        print(item, terminator: i == j ? terminator: separator)
    }
    #endif
}
