//
//  LCControl.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa


/// 自定义的 NSControl，用于支持点击操作（mouseDown/mouseUp）
open class LCControl: NSControl {
    
    // MARK: - Mouse Events
    
    /// 鼠标按下：
    /// - 让自身成为第一响应者，以便接收键盘/焦点事件
    open override func mouseDown(with event: NSEvent) {
        if isEnabled {
            window?.makeFirstResponder(self)
        }
        super.mouseDown(with: event)
    }
    
    /// 鼠标抬起：
    /// - 如果控件可用并且设置了 action，则发送 action 到 target
    open override func mouseUp(with event: NSEvent) {
        guard isEnabled, let action = action else {
            super.mouseUp(with: event)
            return
        }
        
        NSApp.sendAction(action, to: target, from: self)
        super.mouseUp(with: event)
    }
    
    // MARK: - Responder
    
    /// 允许成为第一响应者
    open override var acceptsFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: - View Layout
    
    /// 让坐标系从上往下（macOS 默认是下往上）
    open override var isFlipped: Bool {
        return true
    }
    
}
