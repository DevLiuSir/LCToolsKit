//
//  LCProgressHUDStyle.swift
//  LCLCProgressHUD
//
//  Created by Liu Chuan on 2024/3/8.
//

import Cocoa

/// `ProgressHUD`的颜色方案枚举
public enum LCProgressHUDStyle {
    /// `ProgressHUDStyle` 有浅色背景，*深色* 文字和进度指示器
    case light
    /// `ProgressHUDStyle` 有深色背景，*浅色* 文字和进度指示器
    case dark
    /// `ProgressHUDStyle` 自定义前景和背景颜色
    case custom(foreground: NSColor, backgroud: NSColor)

    /// 根据枚举类型获取`背景颜色`
    var backgroundColor: NSColor {
        switch self {
        case .light: return .white
        case .dark: return .black
        case let .custom(_, background): return background
        }
    }

    /// 根据枚举类型获取`前景颜色`
    public var foregroundColor: NSColor {
        switch self {
        case .light: return .black
        case .dark: return .init(white: 0.95, alpha: 1)
        case let .custom(foreground, _): return foreground
        }
    }
}
