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
        didSet { self.cornerRadius = boxCornerRadius }
    }
    
    /// 边框宽度
    public var boxBorderWidth: CGFloat = 0 {
        didSet { self.borderWidth = boxBorderWidth }
    }
    
    /// 边框颜色
    public var boxBorderColor: NSColor = .clear {
        didSet { self.borderColor = boxBorderColor }
    }
    
    /// 暗色模式下背景色
    public var darkBackgroundColor: NSColor = NSColor(white: 0, alpha: 0.15) {
        didSet { self.needsDisplay = true }
    }
    
    /// 亮色模式下背景色
    public var lightBackgroundColor: NSColor = NSColor(white: 1, alpha: 0.40) {
        didSet { self.needsDisplay = true }
    }
    
    //MARK: 阴影
    
    /// 是否显示阴影
    public var showShadow: Bool = false {
        didSet { updateShadow() }
    }
    
    /// 暗色模式下阴影颜色
    public var darkShadowColor: NSColor = NSColor.black.withAlphaComponent(0.25) {
        didSet { updateShadow() }
    }
    
    /// 浅色模式下阴影颜色
    public var lightShadowColor: NSColor = NSColor.white.withAlphaComponent(0.25) {
        didSet { updateShadow() }
    }
    
    /// 阴影偏移
    public var shadowOffset: NSSize = NSSize(width: 0, height: -4) {
        didSet { updateShadow() }
    }
    
    /// 阴影模糊半径
    public var shadowBlurRadius: CGFloat = 8 {
        didSet { updateShadow() }
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
    
    // 当系统外观（Light / Dark 模式）发生变化时被调用
    // 适合在此方法中更新界面的颜色、图标等外观相关内容
    public override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        setBackgroundColor()
        updateShadow()
        updateBorderColor()
    }
    
    // MARK: - Private Methods
    
    private func configUI() {
        boxType = .custom
        titlePosition = .noTitle
        cornerRadius = boxCornerRadius
        borderWidth = boxBorderWidth
        borderColor = boxBorderColor
        contentViewMargins = .zero
        setBackgroundColor()
        updateShadow()
        updateBorderColor()
    }
    
    /// 根据当前系统外观设置背景颜色
    private func setBackgroundColor() {
        if NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
            self.fillColor = darkBackgroundColor
        } else {
            self.fillColor = lightBackgroundColor
        }
    }
    
    /// 更新阴影
    private func updateShadow() {
        if showShadow {
            let shadow = NSShadow()
            let modeIsDark = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            shadow.shadowColor = modeIsDark ? lightShadowColor : darkShadowColor
            shadow.shadowOffset = shadowOffset
            shadow.shadowBlurRadius = shadowBlurRadius
            self.shadow = shadow
            self.wantsLayer = true
        } else {
            self.shadow = nil
        }
    }
    
    /// 更新边框颜色，可随深浅模式变化
    private func updateBorderColor() {
        let modeIsDark = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        self.borderColor = modeIsDark ? boxBorderColor.withAlphaComponent(0.3) : .clear
    }
}
