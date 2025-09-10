//
//  NSImage+Extension.swift
//
//  Created by DevLiuSir on 2021/3/20
//

import Cocoa

public extension NSImage {
    
    /// 裁剪`图片中心区域`为`正方形`
    ///
    /// - Parameter targetSize: 目标尺寸（例如：60x60）
    /// - Returns: 裁剪后的正方形 NSImage
    func croppedCenterSquare(to targetSize: CGFloat) -> NSImage? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        let squareLength = min(originalWidth, originalHeight)
        
        // 计算中心裁剪区域
        let cropRect = CGRect(
            x: (originalWidth - squareLength) / 2,
            y: (originalHeight - squareLength) / 2,
            width: squareLength,
            height: squareLength
        )
        
        // 从中心裁剪出正方形 CGImage
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else {
            return nil
        }
        
        // 缩放为目标大小（60x60）并转为 NSImage
        let newImage = NSImage(size: NSSize(width: targetSize, height: targetSize))
        newImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        NSImage(cgImage: croppedCGImage, size: .zero)
            .draw(in: NSRect(x: 0, y: 0, width: targetSize, height: targetSize),
                  from: .zero,
                  operation: .copy,
                  fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    /// 返回一个圆形裁剪后的图像
    ///
    /// - Returns: 一个新的圆形图像（NSImage）
    func rounded() -> NSImage {
        // 创建与当前图像相同大小的新图像
        let image = NSImage(size: size)
        image.lockFocus()
        
        // 创建圆形路径并裁剪
        let frame = NSRect(origin: .zero, size: size)
        NSBezierPath(ovalIn: frame).addClip()
        
        // 将原始图像绘制进圆形区域
        draw(at: .zero, from: frame, operation: .sourceOver, fraction: 1)
        
        image.unlockFocus()
        return image
    }
    
    
    /// 创建一个用于`图像遮罩`的`圆角`图形图像
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径，图像尺寸将为该半径的两倍（正方形）
    ///   - fillColor: 填充颜色（例如：黑色用于遮罩）
    /// - Returns: 带有 capInsets 的图像（用于圆角裁剪）
    func maskImage(cornerRadius: CGFloat, fillColor: NSColor) -> NSImage {
        let size = NSSize(width: cornerRadius * 2, height: cornerRadius * 2)
        
        let image = NSImage(size: size, flipped: false) { rect in
            // 填充透明背景
            NSColor.clear.setFill()
            rect.fill()
            
            // 使用圆角矩形路径填充指定颜色
            let bezierPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            fillColor.setFill()
            bezierPath.fill()
            return true
        }
        
        // 设置拉伸区域，保持四个角不被缩放
        image.capInsets = NSEdgeInsets(
            top: cornerRadius,
            left: cornerRadius,
            bottom: cornerRadius,
            right: cornerRadius
        )
        return image
    }
    
    
    /// 顺时针旋转图片（仅支持 90、180、270 度）
    ///
    /// - Parameter degree: 顺时针旋转角度（必须是 90 的倍数）
    /// - Returns: 旋转后的新图像
    func rotate(_ degree: Int) -> NSImage {
        // 归一化角度：防止负角度，限制在 0~359
        var degree = ((degree % 360) + 360) % 360
        
        // 只支持 90 的倍数，并且不能是 0（不旋转）
        guard degree % 90 == 0 && degree != 0 else { return self }
        
        // NSAffineTransform 是逆时针旋转，mpv（或用户）指定的是顺时针，所以取补角
        degree = 360 - degree
        
        // 如果是 180 度，尺寸不变；否则需要交换宽高
        let newSize = (degree == 180 ? self.size : NSMakeSize(self.size.height, self.size.width))
        
        // 创建变换器，先旋转，再平移到画布中心
        let rotation = NSAffineTransform()
        rotation.rotate(byDegrees: CGFloat(degree))
        rotation.append(.init(translationByX: newSize.width / 2, byY: newSize.height / 2))
        
        // 创建新的图像画布
        let newImage = NSImage(size: newSize)
        newImage.lockFocus() // 开始绘图上下文
        
        // 应用变换（旋转 + 平移）
        rotation.concat()
        
        // 原图像尺寸矩形
        let rect = NSMakeRect(0, 0, self.size.width, self.size.height)
        
        // 旋转后，原点需要偏移到左下角对齐旋转中心
        let corner = NSMakePoint(-self.size.width / 2, -self.size.height / 2)
        
        // 绘制图像
        self.draw(at: corner, from: rect, operation: .copy, fraction: 1)
        
        newImage.unlockFocus() // 结束绘图上下文
        
        return newImage
    }
    
    
    
    
    
}

