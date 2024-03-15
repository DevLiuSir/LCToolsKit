//
//  LCProgressHUDMode.swift
//  LCLCProgressHUD
//
//  Created by Liu Chuan on 2024/3/8.
//

import Cocoa

// ProgressHUD操作模式
public enum LCProgressHUDMode {
    /// 使用`旋转的进度指示器`和`状态消息文本`显示进度
    case indeterminate
    /// 使用类似`饼图的圆形进度视图`和`状态消息文本`显示进度
    case determinate
    /// 显示`信息图标`和`状态消息文本`
    case info
    /// 显示`成功图标`和`状态消息文本`
    case success
    /// 显示`错误图标`和`状态消息文本`
    case error
    /// 仅显示`状态消息文本`
    case text
    /// 显示`自定义视图`和`状态消息文本`
    case custom(view: NSView)
}
