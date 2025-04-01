//
//  NSScreen+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//

import Foundation
import AppKit

/// NSScreen 扩展
public extension NSScreen {
    /// x值
    var x: CGFloat { frame.origin.x }
    /// y值
    var y: CGFloat { frame.origin.y }
    /// 宽度
    var width: CGFloat { frame.size.width }
    /// 高度
    var height: CGFloat { frame.size.height }
    /// 大小
    var size: NSSize { frame.size }
    /// 坐标原点
    var origin: NSPoint { frame.origin }
    /// 中心点
    var center: NSPoint { NSMakePoint(centerX, centerY) }
    /// 中心点 x 值
    var centerX: CGFloat { NSMidX(frame) }
    /// 中心点 y 值
    var centerY: CGFloat { NSMidY(frame) }
    /// 最大 x 值
    var maxX: CGFloat { NSMaxX(frame) }
    /// 最大 y 值
    var maxY: CGFloat { NSMaxY(frame) }
    /// 是否是 main screen
    var isMain: Bool { self == NSScreen.main }
    /// 判断`当前屏幕`是否为`内置显示器`
    var isBuiltin: Bool {
        // 尝试从屏幕描述信息中获取屏幕编号
        guard let screenNumber = deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
            return false
        }
        // 使用 CGDisplayIsBuiltin 函数判断是否为内置显示器，并返回结果
        return CGDisplayIsBuiltin(screenNumber) != 0
    }
    
    /// 计算并返回当前屏幕的菜单栏厚度。如果菜单栏不可见，则返回0。
    var menuBarThickness: CGFloat {
        guard let screen = NSScreen.main else { return 0 }
        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame
        
        // 检查屏幕的总高度是否大于可见区域的高度加上可见区域的最小Y值
        // 这表示除了可见区域之外，还有额外的空间被占用，通常这是由于菜单栏和/或Dock
        if (screenFrame.height - visibleFrame.height - visibleFrame.minY) != 0 {
            // 菜单栏可见
            // 注意：这里使用 NSStatusBar.system.thickness 作为菜单栏的厚度可能不完全准确，
            // 因为这个值实际上是状态栏的厚度。通常情况下，这个值和菜单栏的高度相似，但在某些自定义UI主题或系统版本中可能有所不同。
            return NSStatusBar.system.thickness // 默认是：22
        } else {
            // 菜单栏不可见
            return 0
        }
    }
    
    /// 获取`内置显示器`的 `NSScreen 对象`
    static var builtinScreen: NSScreen? {
        // 在所有屏幕中查找第一个标记为内置显示器的 NSScreen 对象并返回
        // 如果没有找到，将返回 nil
        return NSScreen.screens.first { $0.isBuiltin }
    }
    

}
