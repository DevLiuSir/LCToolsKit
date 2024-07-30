//
//  NSColor+Extension.swift
//
//  Created by Liu Chuan on 2024/7/30.
//

import AppKit


// 扩展颜色
public extension NSColor {
    
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
