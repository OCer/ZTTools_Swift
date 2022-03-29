//
//  Double+ZT.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation

public extension Double {
    
    /// 精确double小数点位数（四舍五入）
    ///
    /// - Parameters:
    ///   - fractionDigits: 小数点位数
    /// - Returns: 格式化后的值
    func convertDecimalNumber(fractionDigits: Int) -> String? {
        let decimalNumber = NSDecimalNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        formatter.groupingSeparator = ""
        let result = formatter.string(from: decimalNumber)
        
        return result
    }
    
    /// 精确double小数点位数（不四舍五入）
    ///
    /// - Parameters:
    ///   - fractionDigits: 小数点位数
    /// - Returns: 格式化后的值
    func notRounding(fractionDigits: Int16) -> String {
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .down,
                                                      scale: fractionDigits,
                                                      raiseOnExactness: false,
                                                      raiseOnOverflow: false,
                                                      raiseOnUnderflow: false,
                                                      raiseOnDivideByZero: false)
        
        let ouncesDecimal = NSDecimalNumber(value: self)
        let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: roundingBehavior).stringValue
        
        return roundedOunces
    }
    
    /// 向下取第几位小数
    func inFloor(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return floor(self * divisor) / divisor
    }
    
    /// 截取到第几位小数
    func toFloor(_ places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        return (floor(self * divisor) / divisor).toString(maxF: places)
    }
    
    /// 转化为字符串格式（不四舍五入）
    ///
    /// - Parameters:
    ///   - minF: 小数点最小位数，不足时后置补0
    ///   - maxF: 小数点最大位数，当比这个位数还大时，会被截断（不四舍五入）
    ///   - minI: 整数位数，不足位数时，前置补0
    /// - Returns: 格式化后的值
    func toString(_ minF: Int = 0, maxF: Int = 10, minI: Int = 1) -> String {
        let valueDecimalNumber = NSDecimalNumber(value: self)
        let twoDecimalPlacesFormatter = NumberFormatter()
        twoDecimalPlacesFormatter.maximumFractionDigits = maxF
        twoDecimalPlacesFormatter.minimumFractionDigits = minF
        twoDecimalPlacesFormatter.minimumIntegerDigits = minI
        
        return twoDecimalPlacesFormatter.string(from: valueDecimalNumber)!
    }
    
    /// 转化为字符串格式（四舍五入）
    ///
    /// - Parameters:
    ///   - fractionDigits: 小数点位数
    /// - Returns: 格式化后的值
    func toString(fractionDigits: Int16 = 2) -> String {
        let value = String(format: "%.\(fractionDigits)f", self)
        return value
    }
    
    /**
     缩倍数
     - parameter multiole:除数（不为零）
     - parameter def:保留小数位
     */
    func toMultiple(multiole: Int = 1, def: Int = 6) -> String {
        var str = "0"
        if self > 1000 {
            str =  String(format: "%.\(def)fk", self / 1000)
        } else {
            str = self.toString().subString(def: def)
        }
        
        return str
    }
    
    /**
     除法结果转换为string
     - parameter divisor:除数（不为零）
     - parameter dec:保留小数位
     */
    func divideResultToString(divisor: Double?, dec: Int = 3) -> String {
        guard let divisor = divisor,divisor != 0,self != 0 else {
            return ""
        }
        
        return String(format: "%.\(dec)f", self / divisor)
    }
    
    /**
     乘积换成String
     - parameter multi:乘数
     - parameter dec:保留小数位
     */
    func multiResultToString(multi: Double?, dec: Int = 3) -> String {
        guard let multi = multi,self != 0,multi != 0 else {
            return ""
        }
        
        return String(format: "%.\(dec)f", self * multi)
    }
    
    /// 转为非0字符串，如果数值为0用replace替代
    func toNonZeroString(_ replace: String = "", minF: Int = 0, maxF: Int = 10, minI: Int = 1) -> String {
        if self == 0 {
            return replace
        } else {
            return toString(minF, maxF: maxF, minI: minI)
        }
    }
}
