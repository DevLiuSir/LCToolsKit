//
//  LCCoordinatesAdministrator.swift
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation
import Cocoa



/// 坐标系转换工具（例如屏幕坐标 <-> 视图坐标）
public class LCCoordinatesAdministrator {
    
    // MARK: - 坐标系翻转
    
    /// 将“左上角为原点”的坐标系中的点，转换为 macOS 视图使用的“左下角为原点”的坐标系中的点。
    ///
    /// - Parameter topOriginPoint: 原始坐标（以左上角为原点）
    /// - Returns: 转换后的坐标（以左下角为原点）
    public static func convertFromTopLeftToBottomLeft(_ topOriginPoint: NSPoint) -> NSPoint {
        guard let screen = NSScreen.screens.first(where: { $0.frame.origin == .zero }) else {
            return topOriginPoint
        }
        return NSPoint(x: topOriginPoint.x, y: screen.frame.height - topOriginPoint.y)
    }
    
    /// 将“左下角为原点”的坐标（如视图系统中的坐标）转换为“左上角为原点”的坐标（如屏幕截图坐标）。
    ///
    /// - Parameter bottomOriginPoint: 原始坐标（左下角为原点）
    /// - Returns: 转换后的坐标（左上角为原点）
    public static func convertFromBottomLeftToTopLeft(_ bottomOriginPoint: NSPoint) -> NSPoint {
        guard let screen = NSScreen.screens.first(where: { $0.frame.origin == .zero }) else {
            return bottomOriginPoint
        }
        return NSPoint(x: bottomOriginPoint.x, y: screen.frame.height - bottomOriginPoint.y)
    }
    
    
    // MARK: - 鼠标位置获取
    
    /// 获取当前鼠标在屏幕坐标系中的位置（左下角为原点）
    public static func getMouseLocationInScreen() -> NSPoint {
        return NSEvent.mouseLocation
    }
    
    /// 获取当前鼠标在指定窗口坐标系中的位置（相对于左下角）
    public static func getMouseLocation(in window: NSWindow) -> NSPoint {
        let screenLocation = NSEvent.mouseLocation
        return window.convertPoint(fromScreen: screenLocation)
    }
    
    /// 获取当前鼠标在视图中的位置（如点击事件）
    public static func getMouseLocation(in view: NSView) -> NSPoint? {
        guard let window = view.window else { return nil }
        let windowPoint = getMouseLocation(in: window)
        return view.convert(windowPoint, from: nil)
    }
    
    // MARK: - 屏幕边界辅助
    
    /// 判断一个点是否在主屏幕范围内
    public static func isPointInMainScreen(_ point: NSPoint) -> Bool {
        guard let mainScreen = NSScreen.main else { return false }
        return mainScreen.frame.contains(point)
    }
    
    /// 判断某个窗口是否完全在屏幕范围内
    public static func isWindowFullyVisible(_ window: NSWindow) -> Bool {
        guard let screen = window.screen else { return false }
        return screen.visibleFrame.contains(window.frame)
    }
    
    // MARK: - 屏幕与窗口中心点
    
    /// 获取主屏幕中心点
    public static func getMainScreenCenter() -> NSPoint {
        guard let screen = NSScreen.main else { return .zero }
        return NSPoint(x: screen.frame.midX, y: screen.frame.midY)
    }
    
    /// 获取窗口中心点（基于窗口 frame）
    public static func getWindowCenter(_ window: NSWindow) -> NSPoint {
        let frame = window.frame
        return NSPoint(x: frame.midX, y: frame.midY)
    }
    
}
