//
//  NSTextField+Extension.swift
//
//  Created by DevLiuSir on 2019/3/20
//
import Cocoa

/*
 扩展 NSTextField
 */
public extension NSTextField {
    
    /// 占位符颜色
    var placeholderTextColor: NSColor? {
        get {
            guard let attr = self.placeholderAttributedString else { return nil }
            var range = NSRange(location: 0, length: 0)
            return attr.attribute(.foregroundColor, at: 0, effectiveRange: &range) as? NSColor
        }
        set {
            let placeholderText = self.placeholderString ?? ""
            let attrStr = newValue
                .map { NSAttributedString(string: placeholderText, attributes: [.foregroundColor: $0]) } ??
            NSAttributedString(string: placeholderText)
            self.placeholderAttributedString = attrStr
        }
    }
    
    
    /// 当前文本框是否正在被编辑（拥有第一响应者焦点）
    var isBeingEdited: Bool {
        return self.window?.firstResponder == self.currentEditor()
    }
    
    
    /// 设置背景颜色和圆角样式
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - cornerRadius: 圆角半径（0 表示不设置圆角）
    func setBackgroundStyle(color: NSColor, cornerRadius: CGFloat) {
        isBezeled = false
        drawsBackground = true
        backgroundColor = color
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = cornerRadius > 0
    }
    
    /// 设置字体样式
    /// - Parameters:
    ///   - size: 字体大小
    ///   - isBold: 是否加粗
    func setFont(size: CGFloat, isBold: Bool = false) {
        self.font = isBold ? NSFont.boldSystemFont(ofSize: size) : NSFont.systemFont(ofSize: size)
    }
    
    /// 设置文字颜色
    /// - Parameter color: 文字颜色
    func setTextColor(_ color: NSColor) {
        self.textColor = color
    }
    
    /// 自动适应内容大小
    func sizeToFitWidth() {
        let fittingSize = self.intrinsicContentSize
        self.frame.size.width = fittingSize.width
    }
    
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
    
    
    /// 在给定最大宽度下，自动计算并调整 `NSTextField` 的高度，使其完整显示多行文本内容。固定最大宽度，高度自适应。
    ///
    /// - Parameter maxWidth: 最大允许的宽度，超出会自动换行
    /// - Returns: 调整后的实际尺寸（包含新高度）
    ///
    /// - Note:
    ///   - 适用于多行文本自动适配场景
    ///   - 方法内部会修改 `frame.size`，并启用自动换行
    @discardableResult
    func sizeToFitHeight(maxWidth: CGFloat) -> NSSize {
        // 设置支持自动换行（必要）
        self.lineBreakMode = .byWordWrapping
        self.cell?.usesSingleLineMode = false
        
        // 计算在指定宽度下所需的最佳尺寸（自动计算高度）
        let fittingSize = sizeThatFits(NSSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        // 更新自身尺寸
        var newFrame = self.frame
        newFrame.size = fittingSize
        self.frame = newFrame
        
        return fittingSize
    }
    
    
    
    /// 在 macOS 26+ 移除系统默认背景，并应用自定义圆角和边框样式
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径，默认 6
    ///   - borderColor: 边框颜色，默认浅灰色
    ///   - borderWidth: 边框宽度，默认 1
    @available(macOS 26.0, *)
    func applyCustomStyle(cornerRadius: CGFloat = 6,
                          borderColor: NSColor = NSColor.lightGray.withAlphaComponent(0.6),
                          borderWidth: CGFloat = 1) {
        // ⚠️ macOS 26.0 之后，NSTextField 内部结构发生变化
        // 系统会在搜索框中自动插入一个 NSCoreHostingView 作为背景视图，
        // 该背景视图会覆盖我们自定义的样式（圆角、边框等）
        // 所以需要遍历子视图并隐藏掉该背景视图
        for view in subviews {
            if view.className.contains("NSCoreHostingView") {
                view.isHidden = true
            }
        }
        
        // 应用自定义样式
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        layer?.borderColor = borderColor.cgColor
        layer?.borderWidth = borderWidth
    }
    
    
    
    
}
