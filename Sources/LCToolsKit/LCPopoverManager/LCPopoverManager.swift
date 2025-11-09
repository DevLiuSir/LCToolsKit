//
//
//  LCPopoverManager.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Cocoa


public class LCPopoverManager {
    
    /// 显示锚定到指定视图的 （ NSPopover ） 弹出框。
    /// - Parameters:
    ///   - popover: 已创建的 NSPopover 实例（可选）。若未提供，则默认创建新的 NSPopover。
    ///   - contentViewController: 弹出框内容控制器
    ///   - positioningView: 锚定弹出框的视图
    ///   - preferredEdge: 弹出方向（默认为下方 `.maxY`）
    ///   - behavior: 弹出行为（默认为 `.transient`，点击外部自动关闭）
    @discardableResult
    public static func showPopover(_ popover: NSPopover = NSPopover(), contentViewController: NSViewController, positioningView: NSView, preferredEdge: NSRectEdge = .maxY,
                                   behavior: NSPopover.Behavior = .transient) -> NSPopover {
        popover.behavior = behavior
        popover.contentViewController = contentViewController
        /*
         positionRect： 相对于应该放置弹出框的positioningView中的矩形。通常设置为positioningView的边界。
         可能是一个空矩形，它将默认为positioningView的边界。
         positioningView： 相对应放置弹出框的视图。如果为nil，则导致方法引发invalidArgumentException。
         preferredEdge： 应该优先将popover的positioningView的边缘锚定。
         maxY: 指定视图的底部显示
         maxX: 指定视图的右边显示
         minX: 指定视图的左边显示
         minY: 指定视图的顶部显示
         */
        popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: preferredEdge)
        return popover
    }
    
    
    // MARK: - 常用便捷方法
    
    /// 从下方弹出
    @discardableResult
    public static func showBelow(contentViewController: NSViewController, positioningView: NSView,
                                 popover: NSPopover = NSPopover()) -> NSPopover {
        showPopover(popover, contentViewController: contentViewController, positioningView: positioningView, preferredEdge: .maxY)
    }
    
    /// 从上方弹出
    @discardableResult
    public static func showAbove(contentViewController: NSViewController, positioningView: NSView,
                                 popover: NSPopover = NSPopover()) -> NSPopover {
        showPopover(popover, contentViewController: contentViewController, positioningView: positioningView, preferredEdge: .minY)
    }
    
    /// 从左侧弹出
    @discardableResult
    public static func showLeft(contentViewController: NSViewController, positioningView: NSView,
                                popover: NSPopover = NSPopover()) -> NSPopover {
        showPopover(popover, contentViewController: contentViewController, positioningView: positioningView, preferredEdge: .minX)
    }
    
    /// 从右侧弹出
    @discardableResult
    public static func showRight(contentViewController: NSViewController, positioningView: NSView,
                                 popover: NSPopover = NSPopover()) -> NSPopover {
        showPopover(popover, contentViewController: contentViewController, positioningView: positioningView, preferredEdge: .maxX)
    }
    
    // MARK: - 隐藏方法
    
    /// 隐藏指定的 Popover
    public static func closePopover(_ popover: NSPopover?) {
        popover?.performClose(nil)
    }
    
    
    
    
}
