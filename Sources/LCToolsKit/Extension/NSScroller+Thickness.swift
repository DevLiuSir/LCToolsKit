//
//
//  NSScroller+Thickness.swift
//
//  Created by DevLiuSir on 2021/3/20
//


import Cocoa



public extension NSScroller {
    
    /// 滚动条槽（track / knob slot）的实际厚度
    /// - 说明: 适用于垂直滚动条取宽度，水平滚动条取高度。
    ///   由于 macOS 滚动条方向不同，取 min(width, height) 可以统一处理。
    var knobSlotThickness: CGFloat {
        let thicknessRect = rect(for: .knobSlot)
        return min(thicknessRect.width, thicknessRect.height)
    }
    
    /// 滚动条滑块（thumb / knob）的实际厚度
    /// - 说明: 滑块表示可视区域，大小与内容滚动比例相关。
    var knobThickness: CGFloat {
        let thicknessRect = rect(for: .knob)
        return min(thicknessRect.width, thicknessRect.height)
    }
    
    /// 系统默认滚动条槽厚度
    /// - 说明: 通过 `NSScroller.scrollerWidth(for:controlSize:scrollerStyle:)` 获取系统样式下的标准宽度/高度。
    ///   用于判断当前滚动条槽是否隐藏或缩小（尤其是 overlay style）。
    var defaultKnobSlotThickness: CGFloat {
        return NSScroller.scrollerWidth(for: controlSize, scrollerStyle: scrollerStyle)
    }
    
    /// 滚动条槽是否可见
    /// - 说明: 适用于 macOS 10.14 及以后自动隐藏滚动条的场景。
    ///   当滚动条槽厚度小于默认厚度时，表示滚动条被隐藏或为 overlay 样式。
    var knobSlotVisible: Bool {
        return knobSlotThickness >= defaultKnobSlotThickness
    }
}
