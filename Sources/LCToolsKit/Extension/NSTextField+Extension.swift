//
//  NSTextField+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//
    

import Cocoa


/*
 扩展 NSTextField， 添加一个方法，来限制文字自动调整宽度，解决文字跳动的问题
 */
public extension NSTextField {
    
    /// 调整文本的间距、禁用自动调整文本的宽度，以防止文字跳动。
    /// - Parameter ofSize: 字体的大小，用于设置文本的字体。
    func adjustTextFieldTextSpacing(ofSize: CGFloat) {
        
        // 返回包含等宽数字标志符号的标准系统字体版本。
        font = NSFont.monospacedDigitSystemFont(ofSize: ofSize, weight: .regular)
        
        // 禁用自动调整大小，通常在使用 Auto Layout 时需要禁用。
        translatesAutoresizingMaskIntoConstraints = false
        
        // 一个布尔值，它控制单行文本字段在截断文本之前是否收紧字符间距。
        allowsDefaultTighteningForTruncation = true
        
        // lineBreakMode: 用于控件单元格中文本的换行符模式。
        // .byTruncatingTail： 指示行的值显示，以便开头适合容器，省略号字形指示行尾缺少的文本。
        lineBreakMode = .byTruncatingTail
    }
    
    
    /// 根据给定的最大宽度调整视图尺寸：固定最大宽度，高度自适应。
    ///
    /// - Parameter maxWidth: 最大允许的宽度。
    /// - Returns: 调整后的实际尺寸（宽度 <= maxWidth，高度自适应）。
    @discardableResult
    func sizeWith(maxWidth: CGFloat) -> NSSize {
        let size = sizeThatFits(NSMakeSize(maxWidth, CGFloat.greatestFiniteMagnitude))
        var frame = self.frame
        frame.size = size
        self.frame = frame
        return size
    }
    
}
