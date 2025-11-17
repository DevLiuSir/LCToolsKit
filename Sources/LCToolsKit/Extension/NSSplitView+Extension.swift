//
//  NSSplitView+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//
    
import Cocoa

public extension NSSplitView {

    /// 获取系统默认的分隔线颜色（dividerColor）
    /// 方法：实例化一个 NSSplitView，并设置其分隔样式为 `.thin`，再读取其 dividerColor
    /// 注：这是获取默认颜色的一种方式，目前 macOS 没有提供直接的类方法返回 dividerColor
    static var defaultDividerColor: NSColor = {
        let splitView = NSSplitView()
        splitView.dividerStyle = .thin
        return splitView.dividerColor
    }()
}
