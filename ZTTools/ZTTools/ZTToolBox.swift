//
//  ZTTools.swift
//  XHSG
//
//  Created by Asuna on 2020/7/7.
//  Copyright © 2020 Asuna. All rights reserved.
//

import UIKit
import Photos

public final class ZTToolBox {

    /// 正则表达式（返回匹配个数）；isCaseInsensitive值为true时，不区分大小写
    public class func numberOfRegex(regex: String, and text: String, isCaseInsensitive: Bool = true) -> Int {
        var options: NSRegularExpression.Options = []
        if isCaseInsensitive {
            options = NSRegularExpression.Options.caseInsensitive
        }
        
        if let regular = try? NSRegularExpression(pattern: regex, options: options) {
            return regular.numberOfMatches(in: text, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: text.count))
        }
        
        return 0
    }
    
    /// 正则表达式（返回匹配结果集）；isCaseInsensitive值为true时，不区分大小写
    public class func regex(regex: String, and text: String, isCaseInsensitive: Bool = true) -> Array<String> {
        var list: [String] = [String]()
        var options: NSRegularExpression.Options = []
        if isCaseInsensitive {
            options = NSRegularExpression.Options.caseInsensitive
        }
        
        if let regular: NSRegularExpression = try? NSRegularExpression(pattern: regex, options: options) {
            let array = regular.matches(in: text, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: text.count))
            
            for result in array {
                let range = text.toRange(result.range)
                let str = text.substingInRange(range!)!
                list.append(str)
            }
        }
        
        return list
    }
    
    /// 获取一个URL
    public class func createURL(url: String?) -> URL {
        if (url?.count ?? 0) == 0 {
            return URL(string: "http://0.cn")!
        }

        return URL(string: url!)!
    }
    
    /// 字典转换为JSON字符串
    public class func getJSONStringFromDictionary(dictionary: Dictionary<String, Any>) -> String {
        kLog("json字典 = \(dictionary)")
        
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            kLog("不是合法的json格式")
            
            return ""
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            kLog("无法转出json data")
            
            return ""
        }

        return self.getJSONStringFromData(data: data)
    }
    
    /// data转换为JSON字符串
    public class func getJSONStringFromData(data: Data) -> String {
        let JSONString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""
        
        return JSONString as String
    }
    
    /// json字符串转字典
    public class func getDictionaryFromJSONString(jsonString: String) -> Dictionary<String, Any> {
        let jsonData: Data = jsonString.data(using: .utf8)!
        
        return self.getDictionaryFromJSONData(jsonData: jsonData)
    }
    
    /// json格式的data转字典
    public class func getDictionaryFromJSONData(jsonData: Data) -> Dictionary<String, Any> {
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! Dictionary
        }
        
        return Dictionary()
    }
    
    /// 快速获取一个NSError
    public class func getError(title: String?, message: String?, text: String?, code: Int) -> NSError {
        var userInfo = Dictionary<String, Any>()
        var flag = false
        var error: NSError! = nil
        
        if title != nil {
            flag = true
            userInfo.updateValue(title!, forKey: NSLocalizedDescriptionKey)
        }
        
        if message != nil {
            flag = true
            userInfo.updateValue(message!, forKey: NSLocalizedFailureReasonErrorKey)
        }
        
        if text != nil {
            flag = true
            userInfo.updateValue(text!, forKey: NSLocalizedRecoverySuggestionErrorKey)
        }
        
        if flag {
            error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: userInfo)
        } else {
            error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: nil)
        }
        
        return error
    }
    
    /// 根据path获取文件大小（单位B）
    public class func getFileSizeWithPath(path: String) -> Int {
        let fileManager = FileManager.default
        let dic = try? fileManager.attributesOfItem(atPath: path)
        
        return dic![FileAttributeKey.size] as! Int
    }
    
    /// 数据大小转字符串 （KB、MB等）
    public class func fileSizeToString(fileSize: UInt64) -> String {
        let KB: UInt64 = 1000
        let MB: UInt64 = KB * KB
        let GB: UInt64 = MB * MB

        if fileSize < 10 {
            return "0 B"
        } else if fileSize < KB {
            return String(format: "%.1f KB", (CGFloat)(fileSize))
        } else if fileSize < MB {
            return String(format: "%.1f KB", (CGFloat)(fileSize) / (CGFloat)(KB))
        } else if fileSize < GB {
            return String(format: "%.1f MB", (CGFloat)(fileSize) / (CGFloat)(MB))
        } else {
            return String(format: "%.1f GB", (CGFloat)(fileSize) / (CGFloat)(GB))
        }
    }

    /// 验证身份证
    public class func checkUserIdCard(idCard: String) -> Bool {
        if idCard.count != 18 { // 长度不为18的都排除掉
            return false
        }
        
        // 校验格式
        let regex = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"
        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if identityCardPredicate.evaluate(with: idCard) {  // 格式正确，继续判断是否合法
            // 将前17位加权因子保存在数组里
            let idCardWiArray = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
            
            // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
            let idCardYArray = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
            
            // 用来保存前17位各自乖以加权因子后的总和
            var idCardWiSum: Int = 0
            for index in 0 ..< 17 {
                let subStrIndex: Int = (idCard.substring(index, length: 1)?.toInt())!
                let idCardWiIndex: Int = idCardWiArray[index].toInt()
                idCardWiSum += subStrIndex * idCardWiIndex
            }
            
            // 判断合法性
            let idCardMod: Int = idCardWiSum % 11 // 计算出校验码所在数组的位置
            let idCardLast: String = idCard.substring(17, length: 1)! // 得到最后一位身份证号码
            
            if idCardMod == 2 {  // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
                if (idCardLast == "X") || (idCardLast == "x") {
                    return true
                }
            } else {
                // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if idCardLast == idCardYArray[idCardMod] {
                    return true
                }
            }
        }

        return false
    }
    
    /// 获取自定义相册，如果没有则创建
    public class func createCollectionWithTitle(_ title: String) -> PHAssetCollection? {
        // 创建一个新的相册
        // 查看所有的自定义相册
        // 先查看是否有自己要创建的自定义相册
        // 如果没有自己要创建的自定义相册那么我们就进行创建
        
        let collections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)

        for index in 0 ..< collections.count {
            let collection = collections[index]
            if collection.localizedTitle == title {
                return collection
            }
        }
        
        // 创建相册
        var createCollectionID: String! = nil
        try? PHPhotoLibrary.shared().performChangesAndWait {
            createCollectionID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title).placeholderForCreatedAssetCollection.localIdentifier
        }
        
        if createCollectionID == nil {
            return nil
        }
        
        return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [createCollectionID], options: nil).firstObject
    }
    
    /// 保存图片到自定义相册（异步）
    public class func saveImageToAlbumWithImage(_ image: UIImage, assetCollection: PHAssetCollection, completionBlock: ((_ error: Error?) -> Void)?) {
        PHPhotoLibrary.shared().performChanges({
            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let placeholder = assetChangeRequest.placeholderForCreatedAsset
            assetCollectionChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
        }) { (success, error) in
            if (completionBlock != nil) && success {
                completionBlock!(error)
            }
        }
    }
    
    /// 保存图片到自定义相册（同步）
    public class func saveImageSynchronousToAlbumWithImage(_ image: UIImage, assetCollection: PHAssetCollection, completionBlock: (() -> Void)?) {
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let placeholder = assetChangeRequest.placeholderForCreatedAsset
            assetCollectionChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
        }
        
        if completionBlock != nil {
            completionBlock!()
        }
    }
    
    /// 保存视频到自定义相册（异步）
    public class func saveVideoToAlbumWithURL(_ url: URL, assetCollection: PHAssetCollection, completionBlock: ((_ error: Error?) -> Void)?) {
        PHPhotoLibrary.shared().performChanges({
            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            let placeholder = assetChangeRequest?.placeholderForCreatedAsset
            assetCollectionChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
        }) { (success, error) in
            if (completionBlock != nil) && success {
                completionBlock!(error)
            }
        }
    }
    
    /// 保存视频到自定义相册（同步）
    public class func saveVideoSynchronousToAlbumWithURL(_ url: URL, assetCollection: PHAssetCollection, completionBlock: (() -> Void)?) {
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            let placeholder = assetChangeRequest?.placeholderForCreatedAsset
            assetCollectionChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
        }
        
        if completionBlock != nil {
            completionBlock!()
        }
    }
    
    /// 重置对象的属性
    public class func resetObject(obj: NSObject) {
        var propsCount: UInt32 = 0
        
        let props = class_copyPropertyList(obj.self as? AnyClass, &propsCount)
        for i in 0 ..< propsCount {
            let prop: objc_property_t = props![Int(i)]
            let cName = property_getName(prop)
            let propName = String(utf8String: cName)
            let getPropertyNameString = String(cString: property_getAttributes(prop)!, encoding: String.Encoding.utf8)
            
            if (getPropertyNameString?.contains("@") ?? false) {
                obj.setValue(nil, forKey: propName!)
            } else {
                obj.setValue(NSNumber(value: 0), forKey: propName!)
            }
        }
        
        free(props)
        
        var cls: AnyClass = class_getSuperclass(obj.self as? AnyClass)!
        while cls != NSObject.self {
            var superCount: UInt32 = 0
            let superProps = class_copyPropertyList(cls, &superCount)
            
            for i in 0 ..< superCount {
                let prop: objc_property_t = superProps![Int(i)]
                let cName = property_getName(prop)
                let propName = String(utf8String: cName)
                let getPropertyNameString = String(cString: property_getAttributes(prop)!, encoding: String.Encoding.utf8)
                
                if (getPropertyNameString?.contains("@") ?? false) {
                    obj.setValue(nil, forKey: propName!)
                } else {
                    obj.setValue(NSNumber(value: 0), forKey: propName!)
                }
            }
            
            free(superProps)
            cls = class_getSuperclass(cls)!
        }
    }
    
    /// 获取组件版本
    public class func sdkVersion() -> String {
        return "0.1.3"
    }
}
