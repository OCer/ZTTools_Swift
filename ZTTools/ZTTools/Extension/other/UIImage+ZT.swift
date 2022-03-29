//
//  UIImage+ZT.swift
//  DarkMode
//
//  Created by Asuna on 2022/2/14.
//

import UIKit

public enum ZTGradientDirection: Int {
    case level = 0, vertical, upwardDiagonalLine, downDiagonalLine
}

//      A         B
//       _________
//      |         |
//      |         |
//       ---------
//      C         D
//
// level AC - BD    vertical AB - CD    upwardDiagonalLine A - D    downDiagonalLine C - B
//

public extension UIImage {
    
    /// 获取图片的格式
    func imageType() -> String? {
        let data = self.pngData() ?? Data()
        
        // 创建和初始化指针
        let c: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        c.initialize(repeating: 0, count: 64)
        
        data.copyBytes(to: c, count: 1)
        var type: String! = nil
        
        if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0xFF) {
            type = "image/jpeg"
        } else if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0x89) {
            type = "image/png"
        } else if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0x47) {
            type = "image/gif"
        } else if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0x49) {
            type = "image/tiff"
        } else if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0x4D) {
            type = "image/tiff"
        } else if c == (UnsafeMutablePointer<UInt8>)(bitPattern: 0x52) {
            if data.count >= 12 {
                let str = String(data: data.subdata(in: Range(0 ... 12)), encoding: String.Encoding.ascii)
                if str != nil {
                    if str!.hasSuffix("WEBP") && str!.hasPrefix("RIFF") {
                        type = "webp"
                    }
                }
            }
        }
        
        // 销毁指针
        c.deinitialize(count: 64)
        c.deallocate()
        
        return type
    }
    
    /// 等比率缩放
    func scaleImage(scale: CGFloat) -> UIImage {
        let size = self.size
        let scaleSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(scaleSize)
        self.draw(in: CGRect.init(origin: CGPoint.zero, size: scaleSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    /// 使用颜色创建图片
    class func imageWithColor(color: UIColor, size: CGSize? = nil) -> UIImage? {
        var temp: CGSize!
        
        if size == nil {
            temp = CGSize(width: 1, height: 1)
        } else {
            temp = size!
        }
        
        let rect = CGRect(x: 0, y: 0, width: temp.width, height: temp.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 通过颜色创建渐变图片
    class func getLinearGradientImage(startColor: UIColor, endColor: UIColor, directionType: ZTGradientDirection, size: CGSize) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        switch directionType {
            case .level:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            
            case .vertical:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            
            case .upwardDiagonalLine:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
            case .downDiagonalLine:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0);
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage!
    }
}
