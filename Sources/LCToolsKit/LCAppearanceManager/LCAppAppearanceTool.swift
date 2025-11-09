//
//  LCAppAppearanceTool.swift
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa


/// 管理应用和窗口的外观
public final class LCAppAppearanceTool {
    
    /// 单例
    public static let shared = LCAppAppearanceTool()
    
    private init() {}
    
    // MARK: - App 外观控制
    
    /// 设置整个 App 外观
    /// - Parameter appearance: NSAppearance.Name，默认可用 .aqua、.darkAqua
    public func setAppAppearance(_ appearance: NSAppearance.Name?) {
        if let appearance = appearance {
            NSApp.appearance = NSAppearance(named: appearance)
        } else {
            // 恢复系统默认
            NSApp.appearance = nil
        }
    }
    
    /// 设置 App 为暗色模式
    public func setAppDarkMode() {
        NSApp.appearance = NSAppearance(named: .darkAqua)
    }
    
    /// 设置 App 为亮色模式
    public func setAppLightMode() {
        NSApp.appearance = NSAppearance(named: .aqua)
    }
    
    /// 恢复 App 系统默认外观
    public func resetAppAppearance() {
        NSApp.appearance = nil
    }
    
    // MARK: - Window 外观控制
    
    /// 设置指定窗口的外观
    /// - Parameters:
    ///   - window: 需要控制的 NSWindow
    ///   - appearance: NSAppearance.Name，例如 .darkAqua、.aqua
    public func setWindowAppearance(_ window: NSWindow?, appearance: NSAppearance.Name?) {
        guard let window = window else { return }
        if let appearance = appearance {
            window.appearance = NSAppearance(named: appearance)
        } else {
            window.appearance = nil
        }
    }
    
    /// 恢复窗口系统默认外观
    public func resetWindowAppearance(_ window: NSWindow?) {
        window?.appearance = nil
    }
}
