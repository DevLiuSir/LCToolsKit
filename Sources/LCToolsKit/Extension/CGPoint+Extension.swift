//
//  CGPoint+Extension.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Foundation
import Cocoa

public extension CGPoint {
    
    /// 屏幕翻转后的点
    var screenFlipped: CGPoint {
        .init(x: x, y: NSScreen.screens[0].frame.maxY - y)
    }
}
