//
//
//  LCBaseBox.swift
//
//  Created by DevLiuSir on 2021/3/2.
//


import Foundation
import AppKit

/// 自定义 box
open class LCBaseBox: NSBox {
    
    // MARK: - Public Properties
    
    /// 圆角半径（避免覆盖 NSBox 的同名属性）
    public var boxCornerRadius: CGFloat = 15 {
        didSet {
            self.cornerRadius = boxCornerRadius
        }
    }
    
    /// 暗色模式下背景色
    public var darkBackgroundColor: NSColor = NSColor(white: 0, alpha: 0.15) {
        didSet { self.needsDisplay = true }
    }
    
    /// 亮色模式下背景色
    public var lightBackgroundColor: NSColor = NSColor(white: 1, alpha: 0.40) {
        didSet { self.needsDisplay = true }
    }
    
    // MARK: - Lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    /// 自动响应系统外观切换
    override open func updateLayer() {
        super.updateLayer()
        setBackgroundColor()
    }
    
    
    // MARK: - Private Properties
    
    private func configUI() {
        boxType = .custom
        titlePosition = .noTitle
        cornerRadius = boxCornerRadius
        borderWidth = 0
        contentViewMargins = .zero
        wantsLayer = true
    }
    
    /// 根据当前系统外观设置背景颜色
    private func setBackgroundColor() {
        if NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {     // 暗黑模式
            self.fillColor = darkBackgroundColor
        } else {
            self.fillColor = lightBackgroundColor
        }
    }

}
