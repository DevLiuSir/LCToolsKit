//
//  LCActivityIndicatorManager.swift
//
//  Created by DevLiuSir on 2021/12/26.
//


import Foundation
import AppKit

/// 活动指示器管理员
public class LCActivityIndicatorManager {
    
    /// 控制`活动指示器`动画
    /// - Parameters:
    ///   - indicator: 需要控制动画的组件（类型：NSProgressIndicator）
    ///   - isAnimating: 指示器是否应处于动画状态
    public static func activityIndicatorAnimation(for indicator: NSProgressIndicator, isAnimating: Bool) {
        DispatchQueue.main.async {
            if isAnimating {
                indicator.startAnimation(nil)
                indicator.isHidden = false
            } else {
                indicator.stopAnimation(nil)
                indicator.isHidden = true
            }
        }
    }
    
    
    /// 设置活动指示器的样式
    /// - Parameters:
    ///   - indicator: 需要设置样式的组件
    ///   - style: 样式（默认支持 .spinning 和 .bar）
    public static func setStyle(for indicator: NSProgressIndicator, style: NSProgressIndicator.Style) {
        DispatchQueue.main.async {
            indicator.style = style
        }
    }
    
    /// 设置进度值
    /// - Parameters:
    ///   - indicator: 需要设置进度的组件
    ///   - value: 进度值
    public static func setProgress(for indicator: NSProgressIndicator, value: Double) {
        DispatchQueue.main.async {
            indicator.doubleValue = value
        }
    }
    
    /// 设置最大和最小值
    /// - Parameters:
    ///   - indicator: 需要设置范围的组件
    ///   - min: 最小值
    ///   - max: 最大值
    public static func setProgressRange(for indicator: NSProgressIndicator, min: Double, max: Double) {
        DispatchQueue.main.async {
            indicator.minValue = min
            indicator.maxValue = max
        }
    }
    
    /// 显示或隐藏活动指示器
    /// - Parameters:
    ///   - indicator: 需要控制显示的组件
    ///   - isVisible: 是否显示
    public static func setVisibility(for indicator: NSProgressIndicator, isVisible: Bool) {
        DispatchQueue.main.async {
            indicator.isHidden = !isVisible
        }
    }
    
    /// 设置是否启用为不确定模式
    /// - Parameters:
    ///   - indicator: 需要设置的活动指示器
    ///   - isIndeterminate: 是否启用不确定模式
    public static func setIndeterminate(for indicator: NSProgressIndicator, isIndeterminate: Bool) {
        DispatchQueue.main.async {
            indicator.isIndeterminate = isIndeterminate
        }
    }
    
    /// 设置进度条是否为动画模式
    /// - Parameters:
    ///   - indicator: 需要设置的活动指示器
    ///   - usesThreadedAnimation: 是否启用多线程动画
    public static func setThreadedAnimation(for indicator: NSProgressIndicator, usesThreadedAnimation: Bool) {
        DispatchQueue.main.async {
            indicator.usesThreadedAnimation = usesThreadedAnimation
        }
    }
    
    
    
}
