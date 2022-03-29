//
//  String+ZT.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation

public extension String {
    
    /// 下标获取子字符串
    subscript (r: Range<Int>) -> String? {
        get {
            if (r.lowerBound > count) || (r.upperBound > count) {
                return nil
            }
            
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex ..< endIndex])
        }
    }
    
    /// 根据下标获取对应的字符。若索引正确返回对应的字符，否则返回nil
    subscript(index: Int) -> Character? {
        get {
            if let str = substring(index, length: 1) {
                return Character(str)
            }
            
            return nil
        }
    }
    
    /// 根据起始位置和长度获取子串。如果位置和长度都合理则返回子串，否则返回nil
    func substring(_ location: Int, length: Int) -> String? {
        if location < 0 && location >= self.count {
            return nil
        }
        
        if length <= 0 || length >= self.count {
            return nil
        }
        
        return (self as NSString).substring(with: NSMakeRange(location, length))
    }
    
    /// 获取子字符串
    func substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        
        return String(self[startIndex ..< endIndex])
    }
    
    /// 获取子字符串
    func substingInRange(_ r: Range<String.Index>) -> String? {
        if r.lowerBound < self.startIndex || r.upperBound > self.endIndex {
            return nil
        }
        
        let startIndex = r.lowerBound
        let endIndex = r.upperBound
        
        return String(self[startIndex ..< endIndex])
    }
    
    /// 截取数字字符串，小数位大于8位则截取小数8位后的数字
    func subString(def: Int = 8) -> String {
        let stringArr = self.components(separatedBy: ".")
        var newString = ""
        
        if stringArr.count == 2 {
            if stringArr[1].count > def {
                newString = String(format: "%.\(def)f", (self.toDouble()))
            } else {
                newString = self
            }
            
            if newString.toDouble() == 0 {
                newString = "0"
            }
        } else {
            newString = self
        }
        
        return newString
    }
    
    /// 获取子串的起始位置。如果找不到子串返回NSNotFound，否则返回其所在起始位置
    func location(_ substring: String) -> Int {
        return (self as NSString).range(of: substring).location
    }
    
    /// 判断字符串是否包含子串。如果找到返回true，否则返回false
    func isContain(_ substring: String) -> Bool {
        return (self as NSString).contains(substring)
    }
    
    /// 判断字符串是否全是数字组成，若为全数字组成返回true，否则返回false
    func isOnlyNumbers() -> Bool {
        let set = CharacterSet.decimalDigits.inverted
        let range = (self as NSString).rangeOfCharacter(from: set)
        let flag = range.location != NSNotFound
        
        return flag
    }
    
    /// 判断内容是否全部为空格；true全部为空格，false不是
    func isOnlySpaces() -> Bool {
        if self.count == 0 {
            return true
        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return true
        }

        return false
    }
    
    /// 判断是否全是特殊字符。true全部是，false不是
    func isOnlySpecialCharacter() -> Bool {
        let regex = "[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/" // 规定的特殊字符，可以自己随意添加
        var allIndex = 0
        
        for i in 0 ..< self.count {
            let subStr = self.substring(i, length: 1)
            if regex.location(subStr!) != NSNotFound {
                allIndex += 1
            } else {
                break
            }
        }
        
        if self.count == allIndex {
            return true
        }

        return false
    }
    
    /// 该字符串是否是同一个字符。true全部是，false不是
    func isOnlySameOne() -> Bool {
        if self.count < 2 {
            return false
        }
        
        let character = self.substingInRange(Range(0 ... 1)) // 获取第一个字符作为比较的字符
        var allIndex = 1
        
        for i in 1 ..< self.count {
            let subStr = self.substring(i, length: 1)
            if character == subStr! {
                allIndex += 1
            } else {
                break
            }
        }
        
        if self.count == allIndex {
            return true
        }

        return false
    }
    
    /// 判断字符串是否全是字母组成，若为全字母组成返回true，否则返回false
    func isOnlyLetters() -> Bool {
        let set = CharacterSet.letters.inverted
        let range = (self as NSString).rangeOfCharacter(from: set)
        
        return range.location != NSNotFound
    }
    
    /// 判断字符串是否全是字母和数字组成，若为全字母和数字组成返回true，否则返回false
    func isAlphanum() -> Bool {
        let set = CharacterSet.alphanumerics.inverted
        let range = (self as NSString).rangeOfCharacter(from: set)
        
        return range.location != NSNotFound
    }
    
    /**
     插入字符分隔字符串
     - parameter char:     要插入的字符
     - parameter interval: 间隔数
     */
    func insertCharByInterval(_ char: String, interval: Int) -> String {
        var text = self as NSString
        var newString = ""
        
        while (text.length > 0) {
            let subString = text.substring(to: min(text.length,interval))
            newString = newString + subString
            
            if (subString.count == interval) {
                newString = newString + char
            }
            
            text = text.substring(from: min(text.length,interval)) as NSString
        }
        
        return newString
    }
    
    /// 转Double
    ///
    /// - Parameters:
    ///   - def: 默认值
    ///   - decimal: 舍弃小数位精度
    func toDouble(_ def: Double = 0.0, decimal: Int? = nil) -> Double {
        if !self.isEmpty {
            var doubleValue = Double(self) ?? def
            if let dec = decimal {
                doubleValue = doubleValue.inFloor(dec)
            }
            
            return doubleValue
        } else {
            return def
        }
    }

    /// 转Float
    ///
    /// - Parameters:
    ///   - def: 默认值
    func toFloat(_ def: Float = 0.0) -> Float {
        if !self.isEmpty {
            return Float(self) ?? def
        } else {
            return def
        }
    }
    
    /// 转Int
    ///
    /// - Parameters:
    ///   - def: 默认值
    func toInt(_ def: Int = 0) -> Int {
        if !self.isEmpty {
            return Int(self)!
        } else {
            return def
        }
    }
    
    /// 转Bool
    ///
    /// - Parameters:
    ///   - def: 默认值
    func toBool(_ def: Bool = false) -> Bool {
        if !self.isEmpty {
            let value = Int(self)!
            if value > 0 {
                return true
            } else {
                return false
            }
        } else {
            return def
        }
    }
    
    /// 去小数点后多余的0
    func removeDecimalZero() -> String {
        var outNumber = self
        var i = 1
        
        if self.contains(".") {
            while i < self.count {
                if outNumber.hasSuffix("0") {
                    outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                    i = i + 1
                } else {
                    break
                }
            }
            
            if outNumber.hasSuffix(".") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
            }
            
            return outNumber
        }
        else {
            return self
        }
    }
    
    /// 中文转编码
    func URLEncodedString() -> String {
        let result = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        
        return result ?? self
    }
    
    /// 编码转中文
    func URLDecodedString() -> String {
        return self.removingPercentEncoding ?? self
    }

    /// Range转NSRange
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// NSRange转Range
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        
        return from ..< to
    }
}
