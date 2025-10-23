//
//  LCTextDrawHelper.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa

/// 文本绘制助手
public final class LCTextDrawHelper {
    
    /// 绘制带描边的文字
    /// - Parameters:
    ///   - text: 要绘制的文字
    ///   - font: 字体
    ///   - textColor: 文字颜色
    ///   - strokeColor: 描边颜色
    ///   - strokeWidth: 描边宽度（建议 1~3）
    ///   - rect: 绘制区域
    public static func drawString(_ text: String, font: NSFont, textColor: NSColor,
                                  strokeColor: NSColor,
                                  strokeWidth: CGFloat,
                                  in rect: NSRect) {
        guard !text.isEmpty else { return }
        
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        // 文本属性
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        // 模拟描边（八方向阴影绘制）
        // 对角线方向长度公式 = √(d² + d²) ≈ 1.414 * d
        
        let d = strokeWidth
        let diagonalMultiplier: CGFloat = 1.414  // √2，用于水平/垂直方向偏移
        let offsets: [CGSize] = [
            CGSize(width: diagonalMultiplier * d, height: 0),
            CGSize(width: -diagonalMultiplier * d, height: 0),
            CGSize(width: 0, height: diagonalMultiplier * d),
            CGSize(width: 0, height: -diagonalMultiplier * d),
            CGSize(width: d, height: d),
            CGSize(width: d, height: -d),
            CGSize(width: -d, height: d),
            CGSize(width: -d, height: -d)
        ]
        
        // 绘制描边
        for offset in offsets {
            context.setShadow(offset: offset, blur: 0, color: strokeColor.cgColor)
            text.draw(in: rect, withAttributes: attributes)
        }
        
        // 绘制正文
        context.setShadow(offset: .zero, blur: 0, color: nil)
        text.draw(in: rect, withAttributes: attributes)
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
