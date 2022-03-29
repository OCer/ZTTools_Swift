import UIKit

public extension UIColor {
    
    /// 16进制字符串创建颜色
    convenience init(hexString: String) {
        self.init(hexString: hexString, alpha: 1)
    }
    
    /// 16进制字符串创建颜色，可以设置透明度
    convenience init(hexString: String, alpha: CGFloat) {
        var finalAlpha = alpha
        if finalAlpha < 0 {
            finalAlpha = 0
        } else if finalAlpha > 1 {
            finalAlpha = 1
        }
        
        let hexString = hexString.trimmingCharacters(in: .whitespaces)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:finalAlpha)
    }
    
    /// 16进制数字创建颜色，可以设置透明度
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    /// 动态颜色（用来适配黑暗模式的）
    class func dynamicColor(withColorLight light: UIColor, dark: UIColor?) -> UIColor {
        var color: UIColor = light
        
        if #available(iOS 13.0, *) {
            color = UIColor.init(dynamicProvider: { traitCollection in
                if traitCollection.userInterfaceStyle == .light {
                    return light
                }
                
                return dark ?? light
            })
        }
        
        return color
    }
}
