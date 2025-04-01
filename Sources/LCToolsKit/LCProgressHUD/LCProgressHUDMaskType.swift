//
//  LCProgressHUDMaskType.swift
//  LCLCProgressHUD
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

/// `ProgressHUD`周围视图的遮罩类型
public enum LCProgressHUDMaskType {
    /// 清空背景的`ProgressHUDMaskType`，当HUD显示时允许用户交互
    case none
    /// 清空背景的`ProgressHUDMaskType`，当HUD显示时阻止用户交互
    case clear
    /// 半透明黑色背景的`ProgressHUDMaskType`，当HUD显示时阻止用户交互
    case black
    /// 自定义颜色背景的`ProgressHUDMaskType`，当HUD显示时阻止用户交互
    case custom(color: NSColor)
}

