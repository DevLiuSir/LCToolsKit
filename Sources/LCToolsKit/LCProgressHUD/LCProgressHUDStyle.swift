//
//  LCProgressHUDStyle.swift
//  LCLCProgressHUD
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

/// `ProgressHUD` 的颜色方案枚举
public enum LCProgressHUDStyle {
    /// `ProgressHUDStyle` 有浅色背景，*深色* 文字和进度指示器
    case light
    /// `ProgressHUDStyle` 有深色背景，*浅色* 文字和进度指示器
    case dark
    /// `ProgressHUDStyle` 根据系统外观（深色/浅色模式）自动切换
    case auto
    /// `ProgressHUDStyle` 自定义前景和背景颜色
    case custom(foreground: NSColor, background: NSColor)
    
    /// 根据枚举类型获取 `背景颜色`
    var backgroundColor: NSColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        case .auto:
            return NSApp.effectiveAppearance.name == .darkAqua ? .black : .white
        case let .custom(_, background):
            return background
        }
    }
    
    /// 根据枚举类型获取 `前景颜色`
    public var foregroundColor: NSColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .init(white: 0.95, alpha: 1)
        case .auto:
            return NSApp.effectiveAppearance.name == .darkAqua ? .init(white: 0.95, alpha: 1) : .black
        case let .custom(foreground, _):
            return foreground
        }
    }
    
    /// 自定义比较方法
    public func isEqual(to other: LCProgressHUDStyle) -> Bool {
        switch (self, other) {
        case (.light, .light), (.dark, .dark), (.auto, .auto):
            return true
        case (.custom, .custom):
            return true  // 可以根据具体需求进一步比较 foreground 和 background
        default:
            return false
        }
    }
}


