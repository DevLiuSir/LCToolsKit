//
//  LCProgressHUDMode.swift
//  LCLCProgressHUD
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

// ProgressHUD操作模式
public enum LCProgressHUDMode {
    /// 使用`旋转的进度指示器`和`状态消息文本`显示进度
    case indeterminate
    /// 使用类似`饼图的圆形进度视图`和`状态消息文本`显示进度
    case determinate
    
    /// 显示`信息图标`和`状态消息文本`
    case info(view: NSView)
    
    /// 显示`成功图标`和`状态消息文本`
    case success(view: NSView)
    
    /// 显示`错误图标`和`状态消息文本`
    case error(view: NSView)
    
    /// 仅显示`状态消息文本`
    case text
    
    /// 显示`自定义视图`和`状态消息文本`
    case custom(view: NSView)
    
    
    /// 为 `需要视图` 的情况提供匹配方法
    func with(view: NSView) -> LCProgressHUDMode {
        switch self {
        case .success:
            return .success(view: view)
        case .error:
            return .error(view: view)
        case .custom:
            return .custom(view: view)
        default:
            return self
        }
    }
}
