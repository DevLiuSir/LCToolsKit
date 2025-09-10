//
//  NSImage+Color.swift
//
//  Created by DevLiuSir on 2021/3/20
//
import Cocoa



public extension NSImage {
    
    /// 基于模板图像，返回一个指定颜色的副本
    /// - Parameter color: 要应用的颜色
    /// - Returns: 一个新的 NSImage，使用指定颜色渲染
    func withTintColor(_ color: NSColor) -> NSImage {
        // 要求原图是 template；如果不是也尽量处理
        let src = self.copy() as! NSImage
        src.isTemplate = true
        
        let result = NSImage(size: src.size)
        result.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        
        // 先把原图画上
        src.draw(at: .zero, from: NSRect(origin: .zero, size: src.size), operation: .sourceOver, fraction: 1.0)
        
        // 用 color 覆盖，使用 sourceAtop 以保留原图的 alpha 掩码
        color.set()
        NSRect(origin: .zero, size: src.size).fill(using: .sourceAtop)
        
        result.unlockFocus()
        result.isTemplate = false
        return result
    }
    
    /// 以当前图像为基础，更改图片的颜色
    ///
    /// - Parameter color: 要覆盖应用的颜色（使用 `.sourceAtop` 模式）
    /// - Returns: 渲染后的新图像，如果转换失败则返回 `nil`
    func render(color: NSColor) -> NSImage? {
        guard let img = copy() as? NSImage else { return nil }
        img.lockFocus()
        color.setFill()
        let rect = NSRect(origin: .zero, size: size)
        rect.fill(using: .sourceAtop)
        img.unlockFocus()
        return img
    }
    
    
}
