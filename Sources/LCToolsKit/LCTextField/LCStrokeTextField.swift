//
//  LCStrokeTextField.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa

/// 描边文本
public final class LCStrokeTextField: NSTextField {
    
    /// 全局自定义描边颜色（若设置则优先使用此颜色）
    @objc dynamic public var strokeColor: NSColor?
    
    /// 浅色模式下的描边颜色（默认黑色）
    @objc dynamic public var lightModeStrokeColor: NSColor = .black
    
    /// 深色模式下的描边颜色（默认白色）
    @objc dynamic public var darkModeStrokeColor: NSColor = .white
    
    /// 描边宽度（建议 0.5 ~ 3）
    @objc dynamic public var strokeWidth: CGFloat = 0.5
    
    // MARK: - 绘制描边
    public override func draw(_ dirtyRect: NSRect) {
        /*
         ----------------------------------------------------------------------
         ⚠️ 注意：
         不要调用 super.draw(dirtyRect)
         
         NSTextField 在默认实现中会调用内部的 `drawInterior(withFrame:in:)`
         来绘制文字与背景，这会覆盖我们自定义的文字绘制逻辑。
         
         因此，这里完全接管绘制过程，直接使用 LCTextDrawHelper 绘制文字，
         避免系统自动渲染的文字与描边叠加，产生模糊或重复效果。
         ----------------------------------------------------------------------
         */
        
        
        let text = stringValue
        guard !text.isEmpty else { return }
        
        // 根据当前外观判断默认描边颜色
        let defaultStrokeColor: NSColor
        if #available(macOS 10.14, *) {
            let appearance = effectiveAppearance
            let matched = appearance.bestMatch(from: [.darkAqua, .aqua])
            if matched == .darkAqua {
                defaultStrokeColor = darkModeStrokeColor
            } else {
                defaultStrokeColor = lightModeStrokeColor
            }
        } else {
            defaultStrokeColor = lightModeStrokeColor
        }
        
        // 优先使用 strokeColor，否则根据模式选择默认色
        let finalStrokeColor = strokeColor ?? defaultStrokeColor
        
        // 调用文字绘制助手
        LCTextDrawHelper.drawString(
            text,
            font: font ?? .systemFont(ofSize: NSFont.systemFontSize),
            textColor: .controlAccentColor,
            strokeColor: finalStrokeColor,
            strokeWidth: strokeWidth > 0 ? strokeWidth : 0.5,
            in: bounds
        )
    }
}
