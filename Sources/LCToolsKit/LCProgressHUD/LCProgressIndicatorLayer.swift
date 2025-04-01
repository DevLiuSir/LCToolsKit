//
//  LCProgressIndicatorLayer.swift
//  LCLCProgressHUD
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

/// 进度指示器图层
public class LCProgressIndicatorLayer: CALayer {
    
    /// 指示器是否正在运行
    private(set) var isRunning = false

    /// 指示器颜色
    private var color: NSColor

    /// 计算指示器“鳍片”的大小
    private var finBoundsForCurrentBounds: CGRect {
        let size: CGSize = bounds.size
        let minSide: CGFloat = min(size.width, size.height)
        let width: CGFloat = minSide * 0.095
        let height: CGFloat = minSide * 0.30
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    /// 计算指示器“鳍片”的锚点
    private var finAnchorPointForCurrentBounds: CGPoint {
        let size: CGSize = bounds.size
        let minSide: CGFloat = min(size.width, size.height)
        let height: CGFloat = minSide * 0.30
        return CGPoint(x: 0.5, y: -0.9 * (minSide - height) / minSide)
    }

    /// 动画计时器
    private var animationTimer: Timer?
    
    /// 当前“鳍片”的位置
    private var fposition = 0

    /// “鳍片”淡出的透明度
    private var fadeDownOpacity: CGFloat = 0.0

    /// “鳍片”的数量
    private var numFins = 12

    /// 存储“鳍片”图层的数组
    private var finLayers = [CALayer]()

    /// 初始化方法
    ///
    /// - Parameters:
    ///   - size: 指示器的大小
    ///   - color: 指示器的颜色
    init(size: CGFloat, color: NSColor) {
        self.color = color
        super.init()
        bounds = CGRect(x: -(size / 2), y: -(size / 2), width: size, height: size)
        createFinLayers()
        if isRunning {
            setupAnimTimer()
        }
    }

    /// 必要的初始化方法
    ///
    /// - Parameter aDecoder: 一个解码器
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 析构函数，在对象被销毁时调用
    deinit {
        stopProgressAnimation()
        removeFinLayers()
    }

    /// 开始进度动画
    func startProgressAnimation() {
        isHidden = false
        isRunning = true
        fposition = numFins - 1
        setNeedsDisplay()
        setupAnimTimer()
    }

    /// 停止进度动画
    func stopProgressAnimation() {
        isRunning = false
        disposeAnimTimer()
        setNeedsDisplay()
    }
    
    
    /// “鳍片”位置的动画
    @objc private func advancePosition() {
        fposition += 1
        if fposition >= numFins {
            fposition = 0
        }
        let fin = finLayers[fposition]
        // 设置下一个“鳍片”为完全不透明，但是立即执行，不进行任何动画
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        fin.opacity = 1.0
        CATransaction.commit()
        // 让该“鳍片”将其透明度动画化为透明。
        fin.opacity = Float(fadeDownOpacity)
        setNeedsDisplay()
    }

    /// 移除所有“鳍片”图层
    private func removeFinLayers() {
        for finLayer in finLayers {
            finLayer.removeFromSuperlayer()
        }
    }
    
    /// 创建“鳍片”图层
    private func createFinLayers() {
        removeFinLayers()
        // 创建新的“鳍片”图层
        let finBounds: CGRect = finBoundsForCurrentBounds
        let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
        let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let finCornerRadius: CGFloat = finBounds.size.width / 2
        for i in 0..<numFins {
            let newFin = CALayer()
            newFin.bounds = finBounds
            newFin.anchorPoint = finAnchorPoint
            newFin.position = finPosition
            newFin.transform = CATransform3DMakeRotation(CGFloat(i) * (-6.282185 / CGFloat(numFins)), 0.0, 0.0, 1.0)
            newFin.cornerRadius = finCornerRadius
            newFin.backgroundColor = color.cgColor
            // 设置“鳍片”的初始透明度
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            newFin.opacity = Float(fadeDownOpacity)
            CATransaction.commit()
            // 设置“鳍片”的淡出时间（当它正在进行动画时）
            let anim = CABasicAnimation()
            anim.duration = 0.7
            let actions = ["opacity": anim]
            newFin.actions = actions
            addSublayer(newFin)
            finLayers.append(newFin)
        }
    }

    /// 设置动画计时器
    private func setupAnimTimer() {
        // 为了安全，杀掉任何现有的计时器。
        disposeAnimTimer()
        // 如果不可见，为什么要进行动画？viewDidMoveToWindow将在需要时重新调用此方法。
        animationTimer = Timer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(LCProgressIndicatorLayer.advancePosition), userInfo: nil, repeats: true)
        animationTimer?.fireDate = Date()
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .common)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .default)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .eventTracking)
        }
    }

    /// 销毁动画计时器
    private func disposeAnimTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    /// 重写bounds属性
    public override var bounds: CGRect {
        get {
            return super.bounds
        }
        set(newBounds) {
            super.bounds = newBounds

            // 调整“鳍片”的大小
            let finBounds: CGRect = finBoundsForCurrentBounds
            let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
            let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let finCornerRadius: CGFloat = finBounds.size.width / 2

            // 立即进行全部调整
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            for fin in finLayers {
                fin.bounds = finBounds
                fin.anchorPoint = finAnchorPoint
                fin.position = finPosition
                fin.cornerRadius = finCornerRadius
            }
            CATransaction.commit()
        }
    }

}
