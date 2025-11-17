//
//  LCKeyboardEvents.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa
import Carbon


/// 封装键盘事件模拟功能的工具类。
public final class LCKeyboardEvents {
    
    /// 共享实例（可选）
    public static let shared = LCKeyboardEvents()
    private init() {}
    
    // MARK: - 模拟键盘按下 & 抬起
    /// 模拟键盘按下与抬起（keyDown + keyUp）
    ///
    /// - Parameters:
    ///   - key: 虚拟键码（例如 kVK_LeftArrow）
    ///   - flags: 可选的修饰键（如 .maskCommand, .maskShift）
    ///
    /// 说明：
    /// macOS 在某些环境下（例如沙盒 App），方向键必须加上 `.maskSecondaryFn`
    /// 才能被识别为真实的物理方向键。
    ///
    /// 事件发送顺序：
    /// - 先发送 keyDown
    /// - 再发送 keyUp
    /// 组合成完整的按键过程。
    public func pressKey(_ key: CGKeyCode, flags: CGEventFlags? = nil) {
        
        var modifierFlags = flags ?? []
        
        // 方向键默认必须额外加入 Fn（maskSecondaryFn）
        if key == kVK_LeftArrow ||
            key == kVK_RightArrow ||
            key == kVK_UpArrow ||
            key == kVK_DownArrow {
            
            if !modifierFlags.contains(.maskSecondaryFn) {
                modifierFlags.insert(.maskSecondaryFn)
            }
        }
        
        // MARK: KeyDown
        if let keyDown = CGEvent(keyboardEventSource: nil,
                                 virtualKey: key,
                                 keyDown: true) {
            keyDown.flags = modifierFlags
            keyDown.post(tap: .cgSessionEventTap)
        }
        
        // MARK: KeyUp
        if let keyUp = CGEvent(keyboardEventSource: nil,
                               virtualKey: key,
                               keyDown: false) {
            keyUp.flags = modifierFlags
            keyUp.post(tap: .cgSessionEventTap)
        }
    }
    
    
    
    /// 用于模拟按下一个键以及 Command (⌘) 修饰键
    /// - Parameter key_num: 表示要按下的虚拟键码
    /// - Returns: void
    public func pressKeyAndCmd(_ key_num: CGKeyCode) -> Void {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: key_num, keyDown: true)!
        // `flags` 属性设置为 `CGEventFlags.maskCommand`，表示按下 Command 键
        event.flags = CGEventFlags.maskCommand
        
        // 发送事件
        event.post(tap: CGEventTapLocation.cgSessionEventTap)
    }
    
    
    /// 模拟释放一个键以及 Command (⌘) 修饰键
    /// - Parameter key_num: 表示要释放的虚拟键码
    /// - Returns: void
    public func releaseKeyAndCmd(_ key_num: CGKeyCode) -> Void {
        /// 创建一个 `CGEvent` 对象
        let event = CGEvent(keyboardEventSource: nil, virtualKey: key_num, keyDown: false)!
        // 设置 `flags` 属性为 `CGEventFlags.maskCommand`，表示释放 Command 键
        event.flags = CGEventFlags.maskCommand
        // 发送事件
        event.post(tap: CGEventTapLocation.cgSessionEventTap)
    }
    
    
    
    
    
    
}
