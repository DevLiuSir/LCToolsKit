//
//  LCScrollBarPreferenceManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation



/// 管理 macOS 系统滚动条显示
public final class LCScrollBarPreferenceManager {
    
    
    /// 滚动条显示模式
    public enum LCScrollBarMode: String {
        /// 根据鼠标/触控板自动显示
        case automatic = "Automatic"
        /// 仅在滚动时显示
        case whenScrolling = "WhenScrolling"
        /// 始终显示
        case always = "Always"
    }
    
    /// UserDefaults 中用于控制 macOS 系统滚动条显示策略的键
    private static let key = "AppleShowScrollBars"
    
    
    
    /// 获取当前滚动条显示模式
    ///
    /// - Returns: 当前滚动条显示模式，类型为 `LCScrollBarMode`
    ///            如果未设置，则返回 `.automatic`（自动模式）
    public static func currentMode() -> LCScrollBarMode {
        if let value = UserDefaults.standard.string(forKey: key),
           let mode = LCScrollBarMode(rawValue: value) {
            return mode
        }
        return .automatic
    }
    
    /// 设置滚动条显示模式
    ///
    /// - Parameter mode: 要设置的滚动条显示模式，类型为 `LCScrollBarMode`
    /// - Returns: Bool 值，表示是否成功写入 `UserDefaults` 并同步
    @discardableResult
    public static func setMode(_ mode: LCScrollBarMode) -> Bool {
        UserDefaults.standard.set(mode.rawValue, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    /// 重置滚动条显示模式为系统默认
    ///
    /// - Returns: Bool 值，表示是否成功写入 `UserDefaults` 并同步
    @discardableResult
    public static func resetToDefault() -> Bool {
        return setMode(.automatic)
    }
    
}
