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
    /// 显示器ID
    var displayID: CGDirectDisplayID? {
        // 尝试从屏幕描述信息中获取屏幕编号
        deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
    }
    
    /// 判断`当前屏幕`是否为`内置显示器`
    var isBuiltin: Bool {
        guard let displayID = displayID else {
            return false
        }
        // 使用 CGDisplayIsBuiltin 函数判断是否为内置显示器，并返回结果
        return CGDisplayIsBuiltin(displayID) != 0
    }
    
    /// 返回`当前屏幕``顶部相机区域`（刘海）的高度（仅适用于带刘海的 Mac）
    ///
    /// - Note: 仅在 macOS 12 及以上系统有效；对于没有刘海的屏幕或系统版本过低，将返回 `nil`
    var cameraHousingHeight: CGFloat? {
        if #available(macOS 12.0, *) {
            // 如果 safeAreaInsets.top 为 0，则说明没有刘海；否则返回顶部安全区高度作为相机区域高度
            return safeAreaInsets.top == 0.0 ? nil : safeAreaInsets.top
        } else {
            // 系统版本低于 macOS 12，不支持 safeAreaInsets，无法判断
            return nil
        }
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
