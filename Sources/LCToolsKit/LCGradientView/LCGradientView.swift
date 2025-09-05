//
//
//  LCGradientView.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Cocoa

/// 渐变视图（增强版）
public class LCGradientView: NSView {
    
    // MARK: - 渐变方向枚举
    public enum GradientDirection {
        case horizontal
        case vertical
        case topLeftToBottomRight
        case bottomLeftToTopRight
    }
    
    // MARK: - 渐变图层
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - 基础属性
    
    /// 多色渐变（优先级高于 firstColor/secondColor）
    public var colors: [NSColor] = [] {
        didSet { updateGradient() }
    }
    
    /// 第一个颜色（仅当 colors 为空时生效）
    public var firstColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    
    /// 第二个颜色（仅当 colors 为空时生效）
    public var secondColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    
    /// 渐变位置（与 colors 数组对应，范围 0~1）
    public var locations: [NSNumber]? {
        didSet { updateGradient() }
    }
    
    /// 渐变方向
    public var direction: GradientDirection = .horizontal {
        didSet { updateGradient() }
    }
    
    /// 图层透明度
    public var layerOpacity: Float = 1 {
        didSet { updateGradient() }
    }
    
    /// 渐变圆角
    public var cornerRadius: CGFloat = 0 {
        didSet { updateGradient() }
    }
    
    /// 边框颜色
    public var borderColor: NSColor = .clear {
        didSet { updateGradient() }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat = 0 {
        didSet { updateGradient() }
    }
    
    
    // MARK: - 快捷配置
    /// 快速配置渐变
    public func setColors(_ newColors: [NSColor],
                          direction: GradientDirection = .horizontal,
                          cornerRadius: CGFloat = 0,
                          opacity: Float = 1.0) {
        self.colors = newColors
        self.direction = direction
        self.cornerRadius = cornerRadius
        self.layerOpacity = opacity
        updateGradient()
    }
    
    // MARK: - 生命周期
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        wantsLayer = true
        layer = gradientLayer
        updateGradient()
    }
    
    // MARK: - 更新渐变
    private func updateGradient() {
        // 设置颜色
        if colors.isEmpty {
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        } else {
            gradientLayer.colors = colors.map { $0.cgColor }
        }
        
        // 设置位置
        gradientLayer.locations = locations ?? [0.0, 1.0]
        
        // 设置透明度
        gradientLayer.opacity = layerOpacity
        
        // 设置圆角 & 边框
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.borderColor = borderColor.cgColor
        gradientLayer.borderWidth = borderWidth
        
        // 设置方向
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint   = CGPoint(x: 1, y: 0)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        }
        
        gradientLayer.frame = bounds
    }
    
    // MARK: - 布局更新
    public override func layout() {
        super.layout()
        gradientLayer.frame = bounds
    }
}

