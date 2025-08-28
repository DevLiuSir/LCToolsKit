//
//  NSEvent+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//


import Foundation
import Cocoa

public extension NSEvent {
    
    /// 是否按下了 Fn 键
    var isFunctionPressed: Bool {
        return modifierFlags.contains(.function)
    }
    
    /// 是否按下了 Control 键（^）
    var isControlPressed: Bool {
        return modifierFlags.contains(.control)
    }
    
    /// 是否按下了 Option 键（⌥）
    var isOptionPressed: Bool {
        return modifierFlags.contains(.option)
    }
    
    /// 是否按下了 Command 键（⌘）
    var isCommandPressed: Bool {
        return modifierFlags.contains(.command)
    }
    
    
    /// 判断是否为鼠标滚轮事件（离散滚动）
    var isMouseScroll: Bool {
        // 非连续滚动，并且没有精细滚动增量，一般就是鼠标滚轮
        return phase.isEmpty && !hasPreciseScrollingDeltas
    }
    
    
    /// 判断当前事件是否为触控板两指滚动（高精度滚动）
    ///
    /// - Returns: 如果是触控板滚动事件，返回 true；否则返回 false。
    var isTrackpadScroll: Bool {
        return self.hasPreciseScrollingDeltas
    }
    
    /// 判断当前事件是否为允许的拖动事件（左键按下拖动、三指拖移）
    ///
    /// - Returns: 如果是 `.leftMouseDragged` 类型事件，则返回 `true`，否则返回 `false`
    var isDragEvent: Bool {
        return self.type == .leftMouseDragged
    }
    
    /// 判断当前事件是否为触控板两指滚动
    ///
    /// - Returns: 如果是触控板两指滚动事件（高精度且有滚动增量），返回 true；否则返回 false。
    var isTrackpadTwoFingerScroll: Bool {
        // 确保是高精度滚动事件
        // 是否有有效的滚动增量
        return hasPreciseScrollingDeltas && (scrollingDeltaX != 0 || scrollingDeltaY != 0)
    }
    
}
