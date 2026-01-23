//
//  LCWindowManager.swift
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation
import Cocoa

/// 负责管理`浮窗`的创建和配置
public class LCWindowManager {
    
    /// 单例
    public static let shared = LCWindowManager()
    
    /// 激活当前应用进程（使用 NSRunningApplication）,确保窗口置于最前，即使其他应用在前也不会被遮挡。
    public func activateCurrentAppProcess() {
        let pid = ProcessInfo.processInfo.processIdentifier
        if let app = NSRunningApplication(processIdentifier: pid) {
            app.activate(options: [.activateIgnoringOtherApps])
        }
    }
    
    
    /// 设置`指定窗口`是否`置顶`
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - isOnTop: 是否启用置顶（true 表示置顶，false 表示取消）
    public static func setWindowLevel(for window: NSWindow?, isOnTop: Bool) {
        guard let window = window else { return }
        window.level = isOnTop ? .mainMenu + 1 : .normal
    }
    
    
    /// `禁用`指定标准`窗口按钮`
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - types: 要禁用的按钮类型数组
    public static func disableStandardButtons(for window: NSWindow?, types: [NSWindow.ButtonType]) {
        guard let window = window else { return }
        for type in types {
            window.standardWindowButton(type)?.isEnabled = false
        }
    }
    
    
    
    /// 设置`指定窗口按钮`的`显示状态`
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - types: 按钮类型数组
    ///   - isHidden: 是否隐藏（true 隐藏，false 显示）
    public static func setStandardButtonsHidden(for window: NSWindow?, types: [NSWindow.ButtonType], isHidden: Bool) {
        guard let window = window else { return }
        for type in types {
            window.standardWindowButton(type)?.isHidden = isHidden
        }
    }
    
    
    /// 设置窗口是否可通过点击背景拖动
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - isMovable: 是否可拖动
    public static func setMovableByBackground(for window: NSWindow?, isMovable: Bool) {
        guard let window = window else { return }
        window.isMovableByWindowBackground = isMovable
    }
    
    /// 设置窗口是否允许用户调整大小
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - isResizable: 是否允许调整大小
    public static func setResizable(for window: NSWindow?, isResizable: Bool) {
        guard let window = window else { return }
        window.styleMask = isResizable ? window.styleMask.union(.resizable) : window.styleMask.subtracting(.resizable)
    }
    
    /// 设置窗口是否允许最小化
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - isMinimizable: 是否允许最小化
    public static func setMinimizable(for window: NSWindow?, isMinimizable: Bool) {
        guard let window = window else { return }
        window.styleMask = isMinimizable ? window.styleMask.union(.miniaturizable) : window.styleMask.subtracting(.miniaturizable)
    }
    
    /// 设置窗口圆角半径
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - radius: 圆角半径
    public static func setCornerRadius(for window: NSWindow?, radius: CGFloat) {
        guard let contentView = window?.contentView else { return }
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = radius
        contentView.layer?.masksToBounds = true
    }
    
    /// 设置窗口是否显示阴影
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - hasShadow: 是否有阴影
    public static func setHasShadow(for window: NSWindow?, hasShadow: Bool) {
        guard let window = window else { return }
        window.hasShadow = hasShadow
    }
    
    /// 设置窗口为无边框风格（适合自定义UI）
    /// - Parameter window: 要操作的窗口
    public static func setBorderlessStyle(for window: NSWindow?) {
        guard let window = window else { return }
        window.styleMask = [.borderless]
        window.isOpaque = false
        window.backgroundColor = .clear
    }
    
    /// 将窗口居中显示在屏幕上
    /// - Parameter window: 要操作的窗口
    public static func centerWindow(_ window: NSWindow?) {
        guard let window = window else { return }
        window.center()
    }
    
    /// 设置窗口整体透明度
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - alpha: 透明度（0.0~1.0）
    public static func setAlpha(for window: NSWindow?, alpha: CGFloat) {
        guard let window = window else { return }
        window.alphaValue = alpha
    }
    
    /// 设置窗口是否点击其他区域后自动关闭
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - enabled: 是否开启
    public static func setHidesOnDeactivate(for window: NSWindow?, enabled: Bool) {
        guard let window = window else { return }
        window.hidesOnDeactivate = enabled
    }
    
    /// 获取窗口当前屏幕的缩放比例（适配 Retina 屏）
    /// - Parameter window: 窗口对象
    /// - Returns: 缩放因子（通常为 1.0 或 2.0）
    public static func getBackingScaleFactor(_ window: NSWindow?) -> CGFloat {
        return window?.backingScaleFactor ?? NSScreen.main?.backingScaleFactor ?? 1.0
    }
    
    /// 设置窗口是否忽略鼠标事件（适合透明点击穿透浮窗）
    /// - Parameters:
    ///   - window: 要操作的窗口
    ///   - ignores: 是否忽略
    public static func setIgnoresMouseEvents(for window: NSWindow?, ignores: Bool) {
        window?.ignoresMouseEvents = ignores
    }
    
    /// 保存窗口位置到 UserDefaults
    /// - Parameters:
    ///   - window: 要保存的窗口
    ///   - key: 存储 key
    public static func saveWindowFrame(_ window: NSWindow?, key: String) {
        guard let window = window else { return }
        let frameString = NSStringFromRect(window.frame)
        UserDefaults.standard.set(frameString, forKey: key)
    }
    
    /// 恢复窗口位置（如果存在）
    /// - Parameters:
    ///   - window: 要恢复的窗口
    ///   - key: 存储 key
    public static func restoreWindowFrame(_ window: NSWindow?, key: String) {
        guard let window = window else { return }
        if let frameString = UserDefaults.standard.string(forKey: key) {
            let frame = NSRectFromString(frameString)
            window.setFrame(frame, display: true)
        }
    }
    
}



// MARK: - 窗口几何与坐标转换（基于 Core Graphics）
/// 用于获取屏幕点对应的窗口范围，并将窗口坐标转换为 Cocoa 可用的屏幕坐标
extension LCWindowManager {
    
    /// 获取当前鼠标在屏幕上的位置（CG 坐标系）
    static func currentMouseLocation() -> NSPoint {
        guard let event = CGEvent(source: nil) else {
            return .zero
        }
        return event.location
    }
    
    // MARK: 窗口获取（根据屏幕坐标）
    
    /// 根据屏幕上的点获取对应窗口的 CGRect（Core Graphics 坐标系）
    /// - Parameter point: 屏幕上的点（全局坐标）
    /// - Returns: 对应窗口的 CGRect，如果没有窗口返回 .zero
    static func getWindowRect(at point: NSPoint) -> CGRect {
        // 获取鼠标点所在的 CGWindowID
        let windowNumber = NSWindow.windowNumber(at: point, belowWindowWithWindowNumber: 0)
        // 获取窗口信息
        guard let windowInfoArray = CGWindowListCopyWindowInfo(.optionIncludingWindow, CGWindowID(windowNumber)) as NSArray? as? [[String: Any]],
              let firstWindow = windowInfoArray.first,
              let boundsDict = firstWindow[kCGWindowBounds as String] as? [String: Any]
        else {
            return .zero
        }
        
        var windowRect = CGRect.zero
        CGRectMakeWithDictionaryRepresentation(boundsDict as CFDictionary, &windowRect)
        return windowRect
    }
    
    
    // MARK: 坐标系转换（CG → Cocoa）
    
    /// 将 Core Graphics 坐标系的窗口矩形转换为 Cocoa 坐标系（NSRect）
    /// - Parameter cgRect: Core Graphics 坐标系的 CGRect
    /// - Returns: Cocoa 坐标系的 NSRect
    static func cgWindowRectToScreenRect(_ cgRect: CGRect) -> NSRect {
        // 获取主屏幕高度
        var mainRect = NSScreen.main?.frame ?? .zero
        
        // 确保主屏幕原点为 (0,0)
        for screen in NSScreen.screens {
            if Int(screen.frame.origin.x) == 0 && Int(screen.frame.origin.y) == 0 {
                mainRect = screen.frame
                break
            }
        }
        
        // 转换坐标系
        let rect = NSRect(
            x: cgRect.origin.x,
            y: mainRect.height - cgRect.height - cgRect.origin.y,
            width: cgRect.width,
            height: cgRect.height
        )
        return rect
    }
}


