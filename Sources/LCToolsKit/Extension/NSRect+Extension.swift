//
//  NSRect+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//


import Cocoa

public extension NSRect {
    
    /// 翻转矩形的坐标
    var isFlipped: NSRect {
        .init(origin: .init(x: origin.x, y: NSScreen.screens[0].frame.maxY - maxY), size: size)
    }
    
}
