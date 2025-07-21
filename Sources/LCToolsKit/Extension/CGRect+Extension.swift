//
//  CGRect+Extension.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Cocoa


public extension CGRect {
    
    /// 屏幕翻转后的矩形
    var screenFlipped: CGRect {
        .init(origin: .init(x: origin.x, y: NSScreen.screens[0].frame.maxY - maxY), size: size)
    }

    /// 判断矩形是否为横向（宽度大于高度）
    var isLandscape: Bool { width > height }
}
