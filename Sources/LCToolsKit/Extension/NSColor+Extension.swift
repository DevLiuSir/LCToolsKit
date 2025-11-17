//
//  NSColor+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//

import AppKit


// 扩展颜色
public extension NSColor {
    
    /// 根据系统的浅色、深色模式, 创建亮色｜暗色模式下的颜色
    ///
    /// - Parameters:
    ///   - light: 浅色模式下使用的颜色。
    ///   - dark: 深色模式下使用的颜色。如果为 `nil`，则深色模式也使用 `light`。
    convenience init(light: NSColor, dark: NSColor?) {
        if #available(macOS 10.15, *) {
            self.init(name: nil, dynamicProvider: { appearance in
                if appearance.bestMatch(from: [.darkAqua, .vibrantDark]) == .darkAqua ||
                   appearance.bestMatch(from: [.darkAqua, .vibrantDark]) == .vibrantDark {
                    return dark ?? light
                }
                return light
            })
        } else {
            self.init(cgColor: light.cgColor)!
        }
    }
    
    
    /// 使用十六进制颜色值初始化 NSColor
    /// - Parameters:
    ///   - hex: 颜色的十六进制表示，例如 0xFF0000 表示红色
    ///   - alpha: 透明度，范围为 0.0 ~ 1.0，默认值为 1.0（不透明）
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        // 提取红色分量（右移16位并与0xFF做位与操作）
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        
        // 提取绿色分量（右移8位并与0xFF做位与操作）
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        
        // 提取蓝色分量（直接与0xFF做位与操作）
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        // 使用 RGB 和 Alpha 初始化 NSColor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    
    /// 获取十六进制字符串
    var hexString: String {
        let r = Int(round(redComponent * 255))
        let g = Int(round(greenComponent * 255))
        let b = Int(round(blueComponent * 255))
        let a = Int(round(alphaComponent * 255))
        if a == 255 {
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
    }
    
    
    
    /// 控件强调颜色
    /// - Returns: 控件强调颜色
    static func controlAccentColor() -> NSColor {
        return NSColor.controlAccentColor
    }

    /// 创建 `R/G/B/A` 颜色
    /// - Parameters:
    ///   - red: 红色分量 (0-255)
    ///   - green: 绿色分量 (0-255)
    ///   - blue: 蓝色分量 (0-255)
    ///   - alpha: 透明度 (0-1)
    /// - Returns: 对应的 RGBA 颜色
    static func rgbaColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> NSColor {
        return NSColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    /// 创建 RGB 颜色 (r=g=b, alpha=1)
    /// - Parameter gray: 灰度值 (0-255)
    /// - Returns: 对应的 RGB 颜色
    static func rgbColor(gray: CGFloat) -> NSColor {
        return NSColor(red: gray / 255.0, green: gray / 255.0, blue: gray / 255.0, alpha: 1.0)
    }

    /// 创建 `16 进制`颜色
    /// - Parameter hex: 16 进制颜色值
    /// - Returns: 对应的颜色
    static func hexColor(hex: UInt) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// 创建`随机`颜色
    /// - Returns: 随机颜色
    static func randomColor() -> NSColor {
        let red = CGFloat(arc4random() % 255) / 255.0
        let green = CGFloat(arc4random() % 255) / 255.0
        let blue = CGFloat(arc4random() % 255) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// 创建`半透明黑色`
    /// - Parameter alpha: 透明度 (0-1)
    /// - Returns: 半透明黑色
    static func blackColorWithAlpha(_ alpha: CGFloat) -> NSColor {
        return NSColor(white: 0, alpha: alpha)
    }

    /// 创建`半透明白色`
    /// - Parameter alpha: 透明度 (0-1)
    /// - Returns: 半透明白色
    static func whiteColorWithAlpha(_ alpha: CGFloat) -> NSColor {
        return NSColor(white: 1, alpha: alpha)
    }
}
