//
//  NSView+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//

import Cocoa


/*
 扩展 NSView， 添加图层动画
 */

public extension NSView {
    
    /// 旋转图层 （360度，无限循环）
    /// - Parameter duration: 旋转一周所需的时长
    func rotate(duration: TimeInterval) {
        // 确保图层存在
        guard let layer = layer else { return }

        // 将锚点设置为图层中心
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // 将图层的位置调整到视图中心
        layer.position = CGPoint(x: frame.origin.x + frame.width / 2,
                                 y: frame.origin.y + frame.height / 2)

        // 创建旋转动画
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2.0)     // 旋转一周的角度
        rotation.duration = duration               // 旋转一周的时间
        rotation.repeatCount = Float.infinity       // 无限循环
        // 移除所有动画（以防之前有其他动画）
        layer.removeAllAnimations()

        // 将旋转动画添加到图层
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    //    https://gist.github.com/nazywamsiepawel/e462193f299187d0fc8e#gistcomment-2891783
    /// 暂停图层动画
    func pauseAnimation() {
        // 确保图层存在
        guard let layer = layer else { return }
        
        // 记录当前时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        // 设置图层速度为0，暂停动画
        layer.speed = 0
        
        // 将图层的时间偏移设为当前时间，这样暂停时会保持在当前动画的位置
        layer.timeOffset = pausedTime
    }
    
    /// 恢复图层动画
    func resumeAnimation() {
        // 确保图层存在
        guard let layer = layer else { return }

        // 获取暂停时记录的时间偏移
        let pausedTime = layer.timeOffset

        // 恢复图层速度为正常速度（1）
        layer.speed = 1

        // 重置时间偏移
        layer.timeOffset = 0

        // 重置开始时间
        layer.beginTime = 0

        // 计算自从暂停到现在的时间
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime

        // 设置开始时间为恢复的时间
        layer.beginTime = timeSincePause
    }

    
    // https://gist.github.com/rorz/c279b0acb8659f52c04ae3f86e700571
    
    /// 设置图层的锚点，同时调整位置，确保视图不发生移动
    /// - Parameter anchorPoint: 新的锚点
    func setAnchorPoint(anchorPoint: CGPoint) {
        guard let layer = self.layer else { return }
        
        // 计算新旧锚点在图层坐标系中的位置
        let newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        let oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
        
        // 转换为图层的仿射变换
        let newPointTransformed = newPoint.applying(layer.affineTransform())
        let oldPointTransformed = oldPoint.applying(layer.affineTransform())
        
        // 计算位置的调整量
        var position = layer.position
        position.x -= oldPointTransformed.x
        position.x += newPointTransformed.x
        position.y -= oldPointTransformed.y
        position.y += newPointTransformed.y
        
        // 应用新的锚点和位置
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
}


//MARK: - 指定《逆时针、顺时针、旋转多少度》
public extension NSView {
    
    /// 开始旋转动画
    ///
    /// - Parameters:
    ///   - clockwise: 是否顺时针旋转，默认为 true
    func startAnimation(clockwise: Bool = true) {
        wantsLayer = true
        // 注意⚠️，修改了 anchorPoint 会变更 frame，无法实现预期在效果。在 macOS 上 anchorPoint 默认为 (0,0)
        let oldFrame = layer?.frame
        layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer?.frame = oldFrame!
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        let from: CGFloat = CGFloat.pi * 2
        let end: CGFloat = 0
        rotateAnimation.fromValue = clockwise ? from : end
        rotateAnimation.toValue = clockwise ? end : from
        rotateAnimation.duration = 1
        rotateAnimation.isAdditive = true
        rotateAnimation.repeatDuration = CFTimeInterval.infinity
        layer?.add(rotateAnimation, forKey: "rotateAnimation")
    }
    
    /// 旋转动画
    ///
    /// - Parameters:
    ///   - clockwise: 是否顺时针旋转
    ///   - angle: 旋转角度
    ///   - duration: 动画持续时间，默认为 2.0 秒
    func rotateAnimation(clockwise: Bool, angle: CGFloat, duration: TimeInterval = 2.0) {
        stopAnimation()
        
        let currentRotation = layer?.value(forKeyPath: "transform.rotation.z") as? CGFloat ?? 0.0
        let targetRotation = clockwise ? currentRotation + angle : currentRotation - angle
        
        // 设置 anchorPoint 和 position 以确保以视图中心为旋转中心
        layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = currentRotation
        rotateAnimation.toValue = targetRotation
        rotateAnimation.duration = duration
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false
        layer?.add(rotateAnimation, forKey: "rotateAnimation")
        
        // 更新图层的旋转状态，以确保下一次动画从正确的位置开始
        layer?.setValue(targetRotation, forKeyPath: "transform.rotation.z")
    }
    
    /// 停止旋转动画
    func stopAnimation() {
        layer?.removeAnimation(forKey: "rotateAnimation")
    }
    
    
}


//MARK: - 视图的 渐显 和 渐隐 动画效果
public extension NSView {
 
    /// 切换`渐隐动画`的可见性
    ///
    /// - Parameter duration: 动画持续时间，默认为 0.5 秒
    func toggleFadeAnimation(duration: TimeInterval = 0.5) {
        let isHidden = layer?.opacity == 0.0
        
        if isHidden {
            // 如果当前是隐藏状态，显示渐隐动画
            fadeInAnimation(duration: duration)
        } else {
            // 如果当前是显示状态，隐藏渐隐动画
            fadeOutAnimation(duration: duration)
        }
    }
   
    /// `渐显`动画
    ///
    /// - Parameter duration: 动画持续时间
    private func fadeInAnimation(duration: TimeInterval) {
        // 在开始 新的渐隐动画 之前, 停止之前的 渐显 和 渐隐动画
        stopFadeAnimation()
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")           // 创建渐显动画
        fadeIn.fromValue = 0.0                                      // 初始透明度为 0.0（完全隐藏）
        fadeIn.toValue = 1.0                                        // 最终透明度为 1.0（完全显示）
        fadeIn.duration = duration                                  // 设置动画持续时间
        layer?.opacity = 1.0                                        // 直接将 layer 的透明度设置为最终值，以避免动画结束后回到初始状态
        layer?.add(fadeIn, forKey: "fadeInAnimation")               // 将渐显动画添加到 layer 上，并设置标识符
    }

    /// `渐隐`动画
    ///
    /// - Parameter duration: 动画持续时间
    private func fadeOutAnimation(duration: TimeInterval) {
        // 在开始 新的渐隐动画 之前, 停止之前的 渐显 和 渐隐动画
        stopFadeAnimation()
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")      // 创建渐隐动画
        fadeOut.fromValue = 1.0                                 // 初始透明度为 1.0（完全显示）
        fadeOut.toValue = 0.0                                   // 最终透明度为 0.0（完全隐藏）
        fadeOut.duration = duration                             // 设置动画持续时间
        layer?.opacity = 0.0                                    // 直接将 layer 的透明度设置为最终值，以避免动画结束后回到初始状态
        layer?.add(fadeOut, forKey: "fadeOutAnimation")         // 将渐隐动画添加到 layer 上，并设置标识符
    }

    /// 停止`渐隐`和`渐显`动画
    private func stopFadeAnimation() {
        layer?.removeAnimation(forKey: "fadeInAnimation")
        layer?.removeAnimation(forKey: "fadeOutAnimation")
    }


    
}


//MARK: - 抖动动画
public extension NSView {
    
    /// 抖动（晃动）动画
    /// - Parameter duration: 动画持续时间
    func shake(duration: CFTimeInterval) {
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        // linear: 线性动画
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = duration
        self.layer?.add(shakeGroup, forKey: "shakeIt")
    }
    
}


// MARK: 设置指定角为圆角
public extension NSView {
    
    /// 设置视图的指定角为圆角
    /// - Parameters:
    ///   - corners: 要设置为圆角的角，默认四个角都圆角
    ///   - radius: 圆角的半径
    ///   - backgroundColor: 背景颜色，默认透明
    func setCornerRadius(for corners: CACornerMask = [.layerMinXMinYCorner,
                                                      .layerMaxXMinYCorner,
                                                      .layerMinXMaxYCorner,
                                                      .layerMaxXMaxYCorner],
                         radius: CGFloat, backgroundColor: NSColor = .clear) {
        wantsLayer = true
        clipsToBounds = true
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.maskedCorners = corners
        layer?.cornerRadius = radius
        layer?.masksToBounds = true
    }
    
    
    /// 快速设置背景色
    /// - Parameter color: 背景颜色
    func setBackgroundColor(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
    
}


// MARK: - NSView 视图管理
public extension NSView {
    
    /// 删除所有子视图
    func removeAllSubviews() {
        subviews.forEach {  // 删除所有子视图的扩展，它很快被删除。
            $0.removeFromSuperview()
        }
    }
}
