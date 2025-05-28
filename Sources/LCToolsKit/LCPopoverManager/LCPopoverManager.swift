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
    ///   - popover: 已创建的 NSPopover 实例,  若未提供则会默认创建一个新的 `NSPopover` 实例。
    ///   - contentViewController: 用于管理弹出框内容的视图控制器
    ///   - positioningView: 用于锚定弹出框的位置视图（通常是按钮或控件）
    public static func showPopover(_ popover: NSPopover = NSPopover(), contentViewController: NSViewController, positioningView: NSView) {
        popover.behavior = .transient
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
        popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: .maxY)
    }
    
}
