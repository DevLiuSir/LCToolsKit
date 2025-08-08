//
//  LCVerticalCenteredTextFieldCell.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa


/// 垂直中心点对齐的文本输入框
public class LCVerticalCenteredTextFieldCell: NSTextFieldCell {
    
    /// 重写方法，计算并返回垂直居中文本的矩形框架
    ///
    /// - Parameter rect: 原始矩形框架
    /// - Returns: 调整后的垂直居中矩形框架
    public override func titleRect(forBounds rect: NSRect) -> NSRect {
        var rect = super.titleRect(forBounds: rect)
        // 将文本的矩形框架向下移动，使其在垂直方向上居中
        rect.origin.y += (rect.height - cellSize.height) / 2
        return rect
    }
    
    /// 重写方法，使用垂直居中的文本矩形框架来绘制文本
    ///
    /// - Parameters:
    ///   - cellFrame: 单元格的矩形框架
    ///   - controlView: 控制视图
    public override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        // 绘制垂直居中的文本
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
    
    /// 重写方法，使用垂直居中的文本矩形框架来处理文本选择操作
    ///
    /// - Parameters:
    ///   - rect: 选择矩形框架
    ///   - controlView: 控制视图
    ///   - textObj: 文本对象
    ///   - delegate: 代理对象
    ///   - selStart: 选择起始位置
    ///   - selLength: 选择长度
    public override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        // 处理垂直居中的文本选择操作
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
}

