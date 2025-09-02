//
//  NSWindow+Extension.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Foundation
import AppKit

public extension NSWindow {
    /// x值
    var x: CGFloat {
        set {
            var frame = frame
            frame.origin.x = newValue
            setFrame(frame, display: true)
        }
        get { frame.origin.x }
    }
    
    /// y值
    var y: CGFloat {
        set {
            var frame = frame
            frame.origin.y = newValue
            setFrame(frame, display: true)
        }
        get { frame.origin.y }
    }
    
    /// 宽度
    var width: CGFloat {
        set {
            var frame = frame
            frame.size.width = newValue
            setFrame(frame, display: true)
        }
        get { frame.size.width }
    }
    
    /// 高度
    var height: CGFloat {
        set {
            var frame = frame
            frame.size.height = newValue
            setFrame(frame, display: true)
        }
        get { frame.size.height }
    }
    
    /// 大小
    var size: NSSize {
        set {
            var frame = frame
            frame.size = newValue
            setFrame(frame, display: true)
        }
        get { frame.size }
    }
    
    /// 坐标原点
    var origin: NSPoint {
        set {
            var frame = frame
            frame.origin = newValue
            setFrame(frame, display: true)
        }
        get { frame.origin }
    }
    
    /// 中心点
    var center: NSPoint {
        set {
            var frame = frame
            frame.origin = NSMakePoint(newValue.x - frame.size.width / 2, newValue.y - frame.size.height / 2)
            setFrame(frame, display: true)
        }
        get { NSMakePoint(NSMidX(frame), NSMidY(frame)) }
    }
    
    /// 中心点 x 值
    var centerX: CGFloat {
        set {
            let centerY = center.y;
            center = NSMakePoint(newValue, centerY)
        }
        get { NSMidX(frame) }
    }
    
    /// 中心点 y 值
    var centerY: CGFloat {
        set {
            let centerX = center.x;
            center = NSMakePoint(centerX, newValue)
        }
        get { NSMidY(frame) }
    }
    
    /// 最大 x 值
    var maxX: CGFloat { NSMaxX(frame) }
    
    /// 最大 y 值
    var maxY: CGFloat { NSMaxY(frame) }
    
    /// 顶部
    var top: CGFloat {
        set { y = newValue }
        get { y }
    }
    
    /// 左侧
    var left: CGFloat {
        set { x = newValue }
        get { x }
    }
    
    /// 底部
    var bottom: CGFloat {
        set { y = newValue - height }
        get { y + height }
    }
    
    /// 右侧
    var right: CGFloat {
        set {
            var frame = frame
            frame.origin.x = newValue - width
            setFrame(frame, display: true)
        }
        get { maxX }
    }
    
    /// 自己的中心点
    var centerPoint: NSPoint { NSMakePoint(width / 2, height / 2) }
    
    //MARK: - method
    
    /// 创建一个透明、无系统按钮的窗口
    /// - Returns: 配置好透明背景和隐藏系统按钮的 NSWindow
    static func makeTransparentWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .fullSizeContentView, .miniaturizable, .closable],
            backing: .buffered,
            defer: true
        )
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.backgroundColor = .clear
        window.isOpaque = false
        window.isMovableByWindowBackground = true
        return window
    }
    
}
