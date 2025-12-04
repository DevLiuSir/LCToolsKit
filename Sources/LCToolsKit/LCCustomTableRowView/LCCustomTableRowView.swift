//
//  LCCustomTableRowView.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa


/// 自定义表格视图中的 `行视图`
public class LCCustomTableRowView: NSTableRowView {
    
    // MARK: - Public Properties
    
    /// 鼠标是否在视图内
    public var mouseInside: Bool = false {
        didSet { needsDisplay = true }  // 重新绘制视图
    }
    
    /// 选中行的背景颜色
    public var selectedBackgroundColor: NSColor = NSColor.black.withAlphaComponent(0.35) {
        didSet { needsDisplay = true }
    }
    
    /// 鼠标悬停颜色 - 浅色模式
    public var hoverBackgroundColorLight: NSColor = NSColor.black.withAlphaComponent(0.1) {
        didSet { needsDisplay = true }
    }
    
    /// 鼠标悬停颜色 - 深色模式
    public var hoverBackgroundColorDark: NSColor = NSColor.white.withAlphaComponent(0.1) {
        didSet { needsDisplay = true }
    }
    
    /// 鼠标悬停时实际使用的颜色，根据系统外观动态选择
    private var currentHoverColor: NSColor {
        let isDark = effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        return isDark ? hoverBackgroundColorDark : hoverBackgroundColorLight
    }
    
    /// 行视图背景圆角半径
    public var rowCornerRadius: CGFloat = 10 {
        didSet { needsDisplay = true }
    }
    
    /// 是否在选中行显示圆角
    public var selectedHasCorner: Bool = true {
        didSet { needsDisplay = true }
    }
    
    /// 是否启用鼠标悬停效果
    public var hoverEnabled: Bool = true {
        didSet { needsDisplay = true }
    }
    
    
    /// 选中区域的水平偏移量
    public var selectionOffsetX: CGFloat = 5 {
        didSet { needsDisplay = true }
    }
    
    
    
    // MARK: - Lifecycle
    
    // 强制选中行始终保持高亮状态
    // 即使窗口不在前台或表格失去焦点，文字仍保持白色
    public override var isEmphasized: Bool {
        get { return true }
        set { super.isEmphasized = true }
    }
    
    // 添加鼠标跟踪区域
    public override func updateTrackingAreas() {
        self.trackingAreas.forEach { self.removeTrackingArea($0) }
        let trackingArea = NSTrackingArea(rect: self.bounds,
                                          options: [.mouseEnteredAndExited, .activeAlways],
                                          owner: self,
                                          userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    /** ----------- 通知接收者, 光标 已进入 跟踪矩形 ----------- */
    public override func mouseEntered(with event: NSEvent) {
        guard hoverEnabled else { return }
        mouseInside = true
    }
    
    /** ----------- 通知接收者, 光标 已退出 跟踪矩形 ----------- */
    public override func mouseExited(with event: NSEvent) {
        guard hoverEnabled else { return }
        mouseInside = false
    }
    
    // MARK: - Drawing
    
    /** ------------------ 当行视图处于`选中状态`时，用于绘制选中行的背景 --------------------**/
    // 它会在行视图处于选中状态且需要重新绘制选中行的背景时被调用。
    
    public override func drawSelection(in dirtyRect: NSRect) {
        // 如果处于选中状态
        guard self.selectionHighlightStyle != .none else { return }
        // 更新背景色
        let color = selectedBackgroundColor
        updateBackgroundColor(color, cornerRadius: selectedHasCorner ? rowCornerRadius : 0)
    }
    
    /** --------------------- 自定义绘制行视图的背景，无论行 是否 `被选中` ------------------ **/
    // 它会在首次显示行视图和需要重新绘制行视图背景时被调用
    public override func drawBackground(in dirtyRect: NSRect) {
        // 如果鼠标进入、且没有选中当前行的话，就绘制背景色
        if hoverEnabled && mouseInside && !isSelected {
            updateBackgroundColor(currentHoverColor, cornerRadius: rowCornerRadius)
        }
    }
    
    /** ----------- 当系统外观（浅色 / 深色模式）发生变化时调用 ----------- */
    // 当系统外观（Light / Dark 模式）发生变化时被调用
    // 适合在此方法中更新界面的颜色、图标等外观相关内容
    public override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        // 鼠标悬停时会重新绘制背景
        if hoverEnabled && mouseInside && !isSelected {
            needsDisplay = true
        }
    }
    
    /// 更新 `行视图`的 `背景颜色` 和 `圆角`。
    ///
    /// - Parameters:
    ///   - color: 选中区域的背景颜色。
    ///   - cornerRadius: 圆角半径，用于选中区域的边框圆角。
    private func updateBackgroundColor(_ color: NSColor, cornerRadius: CGFloat) {
        // 获取当前行视图的矩形区域
        let rect = NSRect(x: selectionOffsetX, y: 0, width: self.bounds.width - selectionOffsetX * 2, height: self.bounds.height)
        
        // 根据 PositionX 和单元格的宽度，计算选中区域的矩形
        let selectionRect = NSInsetRect(rect, 2.5, 2.5)
        
        // 设置选中区域的背景颜色
        color.setFill()
        
        // 创建一个带有圆角的矩形路径来表示选中背景
        let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: cornerRadius, yRadius: cornerRadius)
        
        // 填充选中区域的背景颜色
        selectionPath.fill()
    }
    
}
