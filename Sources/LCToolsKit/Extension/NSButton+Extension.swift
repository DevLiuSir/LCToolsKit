//
//
//  NSButton+Extension.swift
//
//  Created by DevLiuSir on 2021/3/20
//


import AppKit

public extension NSButton {
    
    
    /// 使用`指定颜色`对`按钮的图片`进行`着色`（tint）
    ///
    /// - Parameters:
    ///   - color: 要应用的颜色
    ///   - size: 可选的新图像大小。如果为 nil，则使用原始图像大小
    func setImageTintColor(with color: NSColor, size: NSSize? = nil) {
        guard let originalImage = self.image else { return }
        
        let finalSize = size ?? originalImage.size
        let tinted = NSImage(size: finalSize)
        
        tinted.lockFocus()
        
        let rect = NSRect(origin: .zero, size: finalSize)
        originalImage.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1.0)
        
        color.set()
        rect.fill(using: .sourceAtop)
        
        tinted.unlockFocus()
        
        self.image = tinted
    }
    
    
    
    
    
    
}
