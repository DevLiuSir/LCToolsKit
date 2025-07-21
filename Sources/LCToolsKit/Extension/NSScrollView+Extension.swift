//
//
//  NSScrollView+Extension.swift
//
//  Created by DevLiuSir on 2021/3/20
//

import Cocoa


public extension NSScrollView {
    
    /// 重置 `scrollView` 的`缩放`为`原始比例（1.0）`
    /// 默认延迟 0.1 秒执行，确保在图像加载或布局完成后进行缩放
    func resetMagnification() {
        // 延迟执行，强制更新 scrollView 缩放为 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.magnification = 1.0
        }
    }
    
    
    /// 设置 scrollView 的缩放比例（magnification），默认延迟 0.1 秒执行，确保 imageView 已完成布局
    /// - Parameters:
    ///   - factor: 要设置的缩放比例（例如 1.0 表示原始大小）
    ///   - delay: 执行缩放操作的延迟时间，默认值为 0.1 秒
    func setMagnification(to factor: CGFloat, delay: TimeInterval = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.magnification = factor
        }
    }
    
    
    /// 滚动 ScrollView 到指定位置（可视区域左下角对齐指定点）
    /// - Parameter point: 相对于文档视图（documentView）的目标点位置
    func scrollToVisiblePoint(_ point: NSPoint) {
        // 设置内容视图的原点，使可视区域滚动到目标位置
        contentView.scroll(to: point)
        
        // 通知 ScrollView 更新滚动位置
        reflectScrolledClipView(contentView)
    }
    
    
}
