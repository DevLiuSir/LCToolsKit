//
//  LCAppearanceManager.swift
//
//  Created by DevLiuSir on 2019/3/2.
//
import Foundation
import AppKit


/// 表示外观模式
public enum LCAppearanceMode {
    case light
    case dark
    case automatic
}

/// 管理系统外观（暗黑 / 浅色模式）
public final class LCAppearanceManager {
    
    // MARK: - Properties
    
    /// 单例
    public static let shared = LCAppearanceManager()
    
    /// 当前是否是暗黑模式
    public var isDarkModeEnabled: Bool {
        return currentAppearanceMode == .dark
    }
    
    /// 当前是否是自动切换模式
    public var isAutomaticModeEnabled: Bool {
        return currentAppearanceMode == .automatic
    }
    
    /// 当前外观模式
    public var currentAppearanceMode: LCAppearanceMode {
        return detectCurrentAppearanceMode()
    }
    
    /// 监听系统`effectiveAppearance`变化的观察者（用于响应系统外观模式切换）
    private var kvoToken: NSKeyValueObservation?
    
    
    // MARK: - Init
    
    private init() {
        startObservingAppearanceChanges()
    }
    
    deinit {
        stopObservingAppearanceChanges()
    }
    
    
    // MARK: - Public Methods
    
    /// 切换外观模式（仅影响当前应用）
    public func toggleAppearance() {
        if #available(macOS 10.14, *) {
            let currentMode = NSApp.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua])
            // 如果当前是暗色模式，切换到明亮模式；否则切换到暗色模式
            let nextAppearanceName: NSAppearance.Name = (currentMode == .darkAqua) ? .aqua : .darkAqua
            NSApp.appearance = NSAppearance(named: nextAppearanceName)
        }
    }
    
    
    // MARK: - Private Methods
    
    /// 开始监听外观变化
    private func startObservingAppearanceChanges() {
        kvoToken = NSApp.observe(\.effectiveAppearance, options: [.new]) { [weak self] _, _ in
            self?.handleAppearanceChanged()
        }
    }
    
    /// 停止监听
    private func stopObservingAppearanceChanges() {
        kvoToken?.invalidate()
        kvoToken = nil
    }
    
    /// 外观变化处理
    private func handleAppearanceChanged() {
        // 这里可以发送通知或者执行回调，通知界面更新
        NotificationCenter.default.post(name: Notification.Name("LCAppearanceDidChange"), object: nil)
    }
    
    /// 检测当前外观模式
    private func detectCurrentAppearanceMode() -> LCAppearanceMode {
        if #available(macOS 10.14, *) {
            // 检查是否处于: 自动模式
            if UserDefaults.standard.bool(forKey: "AppleInterfaceStyleSwitchesAutomatically") {
                return .automatic
            }
            
            let appearance = NSApp.effectiveAppearance
            // 检查是否为`暗色模式`或`高对比度暗色模式`
            if appearance.bestMatch(from: [.darkAqua, .accessibilityHighContrastDarkAqua]) != nil {
                return .dark
            } else {
                return .light
            }
        }
        // 如果系统版本不支持暗色模式，则默认返回浅色模式
        return .light
    }
}
