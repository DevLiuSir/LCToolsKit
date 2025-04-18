//
//
//  LCCursorManager.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Cocoa

/// 自定义光标管理类
public class LCCursorManager: NSObject {
    
    /// 根据`光标名称`创建并返回一个`自定义光标`
    ///
    /// - Parameter cursorName: 光标名称
    /// - Returns: NSCursor 对象，如果加载失败则返回 nil
    public static func cursor(forName cursorName: String) -> NSCursor? {
        // 光标资源路径
        let cursorPath = "/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/Resources/cursors/"
        let fullCursorPath = (cursorPath as NSString).appendingPathComponent(cursorName)
        
        // 从路径中加载光标图像
        let imagePath = (fullCursorPath as NSString).appendingPathComponent("cursor.pdf")
        let image = NSImage(byReferencingFile: imagePath)
        
        // 从路径中加载光标信息
        let infoPath = (fullCursorPath as NSString).appendingPathComponent("info.plist")
        guard let info = NSDictionary(contentsOfFile: infoPath),
              let hotx = info["hotx"] as? Double,
              let hoty = info["hoty"] as? Double else {
            return nil
        }
        
        // 创建光标对象
        let hotSpot = NSPoint(x: hotx, y: hoty)
        let cursor = NSCursor(image: image ?? NSImage(), hotSpot: hotSpot)
        
        return cursor
    }
    
    /// 返回`左上角/右下角`拖动尺寸光标（resizenorthwestsoutheast）
    ///
    /// - Returns: NSCursor 对象
    public static func topLeftBottomRightResizeCursor() -> NSCursor? {
        return cursor(forName: "resizenorthwestsoutheast")
    }
    
    /// 返回`右上角/左下角`拖动尺寸光标（resizenortheastsouthwest）
    ///
    /// - Returns: NSCursor 对象
    public static func topRightBottomLeftResizeCursor() -> NSCursor? {
        return cursor(forName: "resizenortheastsouthwest")
    }
    
    
    /// 返回默认箭头光标
    public static func arrowCursor() -> NSCursor {
        return NSCursor.arrow
    }
    
    /// 返回十字光标（常用于选区工具）
    public static func crosshairCursor() -> NSCursor {
        return NSCursor.crosshair
    }
    
    /// 返回指针光标（通常用于链接、按钮）
    public static func pointingHandCursor() -> NSCursor {
        return NSCursor.pointingHand
    }
    
    /// 返回文本插入光标（常用于文字编辑）
    public static func IBeamCursor() -> NSCursor {
        return NSCursor.iBeam
    }
    
    /// 隐藏光标（常用于自定义绘图）
    public static func hiddenCursor() {
        NSCursor.hide()
    }
    
    /// 显示当前光标（恢复）
    public static func unhideCursor() {
        NSCursor.unhide()
    }
    
    
}
