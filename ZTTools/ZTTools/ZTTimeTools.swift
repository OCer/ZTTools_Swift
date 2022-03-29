//
//  ZTTimeTools.swift
//  XHSG
//
//  Created by Asuna on 2020/7/10.
//  Copyright © 2020 Asuna. All rights reserved.
//

import UIKit

public final class ZTTimeTools {
    
    /// 时间轴（秒）转字符串（02:55:32）
    public class func getTimeText(currentTime: TimeInterval) -> String {
        let hour = currentTime / 3600
        let minute = (currentTime - hour * 3600) / 60
        let second = (Int)(currentTime) % 60
        var str: String! = nil
        
        if hour > 0 {
            str = String(format: "%02d:%02d:%02d", hour, minute, second)
        } else {
            str = String(format: "%02d:%02d", minute, second)
        }
        
        return str
    }
    
    /// 获取当前系统时间字符串
    public class func getSystemNowTime(formatter: String) -> String {
        let date = Date()
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = formatter
        
        return timeFormatter.string(from: date)
    }
    
    /// 获取两个时间间隔（秒）
    public class func getTimeInterval(startTime: String, endTime: String, formatter: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        
        let timeNumber = Int(dateFormatter.date(from: endTime)!.timeIntervalSince1970 - dateFormatter.date(from: startTime)!.timeIntervalSince1970)
        
        return timeNumber
    }
    
    /// 根据秒数和间隔标识获取时间字符串（日时分秒），带前导的0
    public class func getTimeStringWithDDHHMMSS(seconds: Int, marginString: String) -> String {
        let str_day = String(format: "%02ld\(kLocalizedString(key: "day")) ", seconds / 86400)
        let str_hour = String(format: "%02ld", (seconds % 86400) / 3600)
        let str_minute = String(format: "%02ld", (seconds % 3600) / 60)
        let str_second = String(format: "%02ld", seconds % 60)
        let format_time = str_day + str_hour + marginString + str_minute + marginString + str_second
        
        return format_time
    }
    
    /// 根据秒数和间隔标识获取时间字符串（日时分秒），不带前导的0
    public class func getTimeStringWithDHHMMSS(seconds: Int, marginString: String) -> String {
        let str_day = String(format: "%ld\(kLocalizedString(key: "day")) ", seconds / 86400)
        let str_hour = String(format: "%02ld", (seconds % 86400) / 3600)
        let str_minute = String(format: "%02ld", (seconds % 3600) / 60)
        let str_second = String(format: "%02ld", seconds % 60)
        let format_time = str_day + str_hour + marginString + str_minute + marginString + str_second
        
        return format_time
    }
    
    /// 根据秒数和间隔标识获取时间字符串（时分秒）
    public class func getTimeStringWithHHMMSS(seconds: Int, marginString: String) -> String {
        let str_hour = String(format: "%02ld", seconds / 3600)
        let str_minute = String(format: "%02ld", (seconds % 3600) / 60)
        let str_second = String(format: "%02ld", seconds % 60)
        let format_time = str_hour + marginString + str_minute + marginString + str_second
        
        return format_time
    }
    
    /// 获取当前时间的时间戳（秒为单位）
    public class func getNowTimeStamp() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        let a = date.timeIntervalSince1970
        let timeStamp = String.init(format: "%.f", a)
        
        return timeStamp
    }
    
    /// 获取当前时间的时间戳（毫秒为单位）
    public class func getNowTimeStampWithMillisecond() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS" // 设置时间格式；hh—>12小时制， HH—>24小时制
        
        // 设置时区
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        formatter.timeZone = timeZone
        let dateNow = Date() // 当前时间
        let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970) * 1000)
        
        return timeStamp
    }
    
    /// 时间戳转时间格式的字符串（自动识别单位）
    public class func timeStampToString(timeStamp: Int, outputFormatter: String) -> String {
        let timeString = String(format: "%ld", timeStamp)
        let timeSta: TimeInterval
        if timeString.count == 10 {
            timeSta = TimeInterval(timeStamp)
        } else {
            timeSta = TimeInterval(timeStamp / 1000)
        }
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = outputFormatter
        
        return dfmatter.string(from: date as Date)
    }
}
