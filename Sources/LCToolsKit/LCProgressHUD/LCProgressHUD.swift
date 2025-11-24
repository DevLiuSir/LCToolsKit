//
//  LCLCProgressHUD.swift
//  LCLCProgressHUD
//
//  Created by DevLiuSir on 2021/6/24.
//

import Cocoa

/// `LCProgressHUDDismissCompletion` 是一个没有参数和返回值的闭包类型，用于 `LCProgressHUD` 解除后的操作
public typealias LCProgressHUDDismissCompletion = () -> Void



public class LCProgressHUD: NSView {
    
    static let shared = LCProgressHUD()
    
    /// 存储 dismiss 结束后的回调
    private var dismissCompletion: LCProgressHUDDismissCompletion?

    // MARK: - Lifecycle
    
    private override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        // 设置视图
        autoresizingMask = [.maxXMargin, .minXMargin, .maxYMargin, .minYMargin]
        alphaValue = 0.0
        isHidden = true

        // 设置状态消息标签
        statusLabel.font = font
        statusLabel.isEditable = false
        statusLabel.isSelectable = false
        statusLabel.alignment = .center
        statusLabel.backgroundColor = .clear
        addSubview(statusLabel)

        // 设置显示 HUD 的窗口
        let screen = NSScreen.screens[0]
        let window = NSWindow(contentRect: screen.frame, styleMask: .borderless, backing: .buffered, defer: true, screen: screen)
        window.level = .floating
        window.backgroundColor = .clear
        windowController = NSWindowController(window: window)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Customization
    
    /// 设置`LCProgressHUDStyle`颜色方案（默认为.light）
    public class func setDefaultStyle(_ style: LCProgressHUDStyle) { LCProgressHUD.shared.style = style }
    /// 默认样式：自动
    fileprivate var style: LCProgressHUDStyle = .auto
    
    
    /// 设置`默认遮罩类型`
    /// - Parameter maskType: 遮罩类型（默认为.none）
    public class func setDefaultMaskType(_ maskType: LCProgressHUDMaskType) { LCProgressHUD.shared.maskType = maskType }
    private var maskType: LCProgressHUDMaskType = .none
    
    /// 设置`LCProgressHUDPosition`在视图中的位置（默认为.bottom）
    public class func setDefaultPosition(_ position: LCProgressHUDPosition) { LCProgressHUD.shared.position = position }
    private var position: LCProgressHUDPosition = .center
    
    /// 设置用于显示`LCProgressHUD`的容器视图。如果为nil，则将使用主屏幕。
    public class func setContainerView(_ view: NSView?) { LCProgressHUD.shared.containerView = view }
    private var containerView: NSView?
    
    /// 设置用于`显示HUD状态消息的字体`（默认为systemFontOfSize: 18）
    public class func setFont(_ font: NSFont) { LCProgressHUD.shared.font = font }
    private var font = NSFont.systemFont(ofSize: 18)
    
    /// HUD视图的`透明度`（默认为0.9）
    public class func setOpacity(_ opacity: CGFloat) { LCProgressHUD.shared.opacity = opacity }
    private var opacity: CGFloat = 0.9
    
    /// 进度旋转器在`水平`和`垂直方向`上的大小（默认为60点）
    public class func setSpinnerSize(_ size: CGFloat) { LCProgressHUD.shared.spinnerSize = size }
    private var spinnerSize: CGFloat = 60.0
    
    /// HUD`边缘`和HUD`元素`（标签，指示器或自定义视图）之间的空间量
    public class func setMargin(_ margin: CGFloat) { LCProgressHUD.shared.margin = margin }
    private var margin: CGFloat = 18.0
    
    /// HUD元素（标签，指示器或自定义视图）之间的空间量
    public class func setPadding(_ padding: CGFloat) { LCProgressHUD.shared.padding = padding }
    private var padding: CGFloat = 4.0
    
    /// HUD的`圆角半径`
    public class func setCornerRadius(_ radius: CGFloat) { LCProgressHUD.shared.cornerRadius = radius }
    private var cornerRadius: CGFloat = 15.0
    
    /// 允许用户通过点击事件手动关闭HUD（默认为false）
    public class func setDismissable(_ dismissable: Bool) { LCProgressHUD.shared.dismissible = dismissable }
    private var dismissible = false
    
    
    // MARK: - 获取 Bundle 里面的图片
    
    /// 从 LCProgressHUD.bundle 中加载指定名称的图片
    ///
    /// - Parameter imageName: 图片文件名（例如 `"success_white@2x.png"`）
    /// - Returns: 加载的 `NSImage` 对象；如果加载失败，则返回空白 `NSImage()`
    private class func bundleImage(_ imageName: String) -> NSImage {
        // 从当前类的 Bundle 中获取 LCProgressHUD.bundle
        guard let resourceBundle = Bundle(for: LCProgressHUD.self).url(forResource: "LCProgressHUD", withExtension: "bundle"),
              let bundle = Bundle(url: resourceBundle) else {
            return NSImage()
        }
        // 尝试加载图片
        guard let imagePath = bundle.path(forResource: imageName, ofType: nil),
              let image = NSImage(contentsOfFile: imagePath) else {
            return NSImage()
        }
        return image
    }
    
    
    // MARK: - Presentation
    
    /// 显示一个不确定的`LCProgressHUD`，没有状态消息
    public class func show() {
        LCProgressHUD.show(withStatus: "")
    }
    
    /// 显示一个带有状态消息的不确定的`LCProgressHUD`
    /// - Parameter status: 显示的信息文本
    public class func show(withStatus status: String) {
        LCProgressHUD.shared.show(withStatus: status, mode: .indeterminate)
    }
    
    /// 显示`成功状态`信息
    public class func showSuccessWithStatus(_ status: String) {
        showStatus(status, type: .success(view: createImageView(for: "success")))
    }

    /// 显示`错误状态`信息
    public class func showErrorWithStatus(_ status: String) {
        showStatus(status, type: .error(view: createImageView(for: "error")))
    }
    
    /// 显示`提示状态`信息
    ///
    /// - Parameter status: 提供的状态信息文本，将在进度HUD中显示
    public class func showInfoWithStatus(_ status: String) {
        showStatus(status, type: .info(view: createImageView(for: "info")))
    }
    
    /// 只显示`文本`信息的方法
    ///
    /// - Parameter status: 提供的状态信息，将在进度HUD中显示
    public class func showTextWithStatus(_ status: String) {
        /// 使用给定的状态信息和模式（.text）来显示进度HUD
        LCProgressHUD.shared.show(withStatus: status, mode: .text)
        
        /// 在一定的延迟后消失，延迟的时间由状态信息的展示持续时间决定
        LCProgressHUD.dismiss(delay: LCProgressHUD.shared.displayDuration(for: status))
    }

    
    /// 显示`图像`和`状态信息文本`方法
    ///
    /// - Parameters:
    ///   - image: 提供的图像，将在进度HUD中显示
    ///   - status: 提供的状态信息
    public class func showImage(_ image: NSImage, status: String) {
        /// 创建一个包含图像的视图
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.image = image
        /// 使用给定的状态信息和模式（.custom(view: imageView)）来显示进度HUD
        LCProgressHUD.shared.show(withStatus: status, mode: .custom(view: imageView))
        /// 在一定的延迟后消失，延迟的时间由状态信息的展示持续时间决定
        LCProgressHUD.dismiss(delay: LCProgressHUD.shared.displayDuration(for: status))
    }
    
    
    /// `隐藏进度HUD`的方法
    ///
    /// - Parameters:
    ///   - delay: 延迟的时间间隔（以秒为单位），默认为 `0`（立即隐藏）
    ///   - completion: `LCProgressHUD` 解除后的完成闭包（可选，默认为 `nil`）
    public class func dismiss(delay: TimeInterval = 0, completion: LCProgressHUDDismissCompletion? = nil) {
        let hud = LCProgressHUD.shared
        hud.dismissCompletion = completion  // 存储 completion 回调

        // 判断是否需要延迟隐藏
        if delay > 0 {
            // 如果 delay 大于 0，则延迟执行隐藏操作
            hud.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
        } else {
            hud.hide(true)             // 如果 delay 为 0，则立即隐藏
            completion?()         // 如果提供了 completion 回调，则立即执行
        }
    }
    
    
    /// 显示一个带有进度和状态的`LCProgressHUD`
    ///
    /// - Parameter progress: 进度值，范围在0.0到1.0之间
    /// - Parameter status: 状态消息，显示在进度条下方
    public class func show(progress: Double) {
        LCProgressHUD.show(progress: progress, status: LCProgressHUD.shared.statusLabel.string)
    }
    
    /// 显示一个带有进度和状态的`LCProgressHUD`
    ///
    /// - Parameter progress: 进度值，范围在0.0到1.0之间
    /// - Parameter status: 状态消息，显示在进度条下方
    public class func show(progress: Double, status: String) {
        LCProgressHUD.shared.show(progress: progress, status: status)
    }
    
    
    /// 设置`LCProgressHUD`的状态
    ///
    /// - Parameter status: 需要设置的状态消息
    public class func setStatus(_ status: String) {
        /// 如果`LCProgressHUD`当前处于隐藏状态，则不进行任何操作
        if LCProgressHUD.shared.isHidden {
            return
        }
        LCProgressHUD.shared.setStatus(status)
    }
    
    /// 如果当前正在显示 `LCProgressHUD`，则返回 `true`
    ///
    /// - Returns: 如果 `LCProgressHUD` 当前正在显示，则为 `true`
    public class func isVisible() -> Bool {
        return !LCProgressHUD.shared.isHidden
    }

    
    // MARK: - Private Properties
    
    /// 创建一个用于状态指示的 `NSImageView`
    ///
    /// - Parameter type: 状态类型 (`"success"` 或 `"error"`)
    /// - Returns: 配置好的 `NSImageView`
    private class func createImageView(for type: String) -> NSView {
        let currentStyle = LCProgressHUD.shared.style

        // 根据当前样式获取正确的图片
        let imageName: String
        switch currentStyle {
        case .dark:
            imageName = "\(type)_white@2x.png"
        case .light:
            imageName = "\(type)_black@2x.png"
        case .auto:
            // 根据系统外观动态选择图标
            imageName = NSApp.effectiveAppearance.name == .darkAqua ? "\(type)_white@2x.png" : "\(type)_black@2x.png"
        case .custom:
            imageName = "\(type)_black@2x.png" // 自定义模式默认黑色图标
        }

        // 创建并返回 `NSImageView`
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = bundleImage(imageName)
        return imageView
    }
    
    
    /// 显示`状态信息`的方法（成功/错误）
    ///
    /// - Parameters:
    ///   - status: 提供的状态信息，将在进度HUD中显示
    ///   - type: 要显示的状态类型（成功/错误）
    private class func showStatus(_ status: String, type: LCProgressHUDMode) {
        // 当前外观样式
        let currentStyle = LCProgressHUD.shared.style
        // 获取对应样式的图像
        let image = imageForStatus(type, style: currentStyle)
        
        // 创建图像视图
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = image
        
        // 处理 .success 和 .error 自动附加视图
        let finalMode: LCProgressHUDMode
        switch type {
        case .success:
            finalMode = .success(view: imageView)
        case .error:
            finalMode = .error(view: imageView)
        case .info:
            finalMode = .error(view: imageView)
        default:
            finalMode = type
        }
        
        // 显示进度 HUD
        LCProgressHUD.shared.show(withStatus: status, mode: finalMode)
        
        // 在一定的延迟后消失
        LCProgressHUD.dismiss(delay: LCProgressHUD.shared.displayDuration(for: status))
    }
   
    
    /// 获取对应的状态图标
    ///
    /// - Parameters:
    ///   - type: HUD 的状态类型（成功/错误）
    ///   - style: 当前 HUD 样式
    /// - Returns: 对应的 NSImage
    private class func imageForStatus(_ type: LCProgressHUDMode, style: LCProgressHUDStyle) -> NSImage? {
        let imageName: String
        switch type {
        case .success:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "success_white@2x.png" : "success_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "success_white@2x.png" : "success_black@2x.png"
            }
        case .error:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "error_white@2x.png" : "error_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "error_white@2x.png" : "error_black@2x.png"
            }
        case .info:
            if style.isEqual(to: .auto) {
                imageName = NSApp.effectiveAppearance.name == .darkAqua ? "info_white@2x.png" : "info_black@2x.png"
            } else {
                imageName = style.isEqual(to: .dark) ? "info_white@2x.png" : "info_black@2x.png"
            }
        default:
            return nil
        }
        return bundleImage(imageName)
    }
    
    
    
    
    
    /// LCProgressHUD操作模式，默认为.indeterminate
    private var mode: LCProgressHUDMode = .indeterminate
    /// 指示器视图
    private var indicator: NSView?
    /// 进度指示器
    private var progressIndicator: LCProgressIndicatorLayer!
    /// HUD的大小，初始为.zero
    private var size: CGSize = .zero
    /// 是否使用动画，初始值为true
    private var useAnimation = true
    /// 显示状态信息的标签
    private let statusLabel = NSText(frame: .zero)
    /// HUD消失后的回调函数
    private var completionHandler: LCProgressHUDDismissCompletion?
    /// 进度值，范围0~1，变化时需要重新布局和绘制
    private var progress: Double = 0.0 {
        didSet {
            needsLayout = true
            needsDisplay = true
        }
    }
    /// HUD的垂直偏移量，取值依赖于HUD的位置
    private var yOffset: CGFloat {
        switch position {
        case .top: return -bounds.size.height / 5
        case .center: return 0
        case .bottom: return bounds.size.height / 5
        }
    }
    /// HUD的显示视图，如果containerView有值就使用containerView，否则使用windowController的contentView
    private var hudView: NSView? {
        if let view = containerView {
            windowController?.close()
            return view
        }
        windowController?.showWindow(self)
        return windowController?.window?.contentView
    }
    /// HUD自动消失的最短时间，默认为2秒
    private let minimumDismissTimeInterval: TimeInterval = 2
    /// HUD自动消失的最长时间，默认为5秒
    private let maximumDismissTimeInterval: TimeInterval = 5
    /// HUD的窗口控制器
    private var windowController: NSWindowController?
    
    

    // MARK: - Private Show & Hide methods
    
    /// 显示进度指示器
    ///
    /// - Parameters:
    ///   - status: 状态信息
    ///   - mode: 进度指示器样式
    private func show(withStatus status: String, mode: LCProgressHUDMode) {
        guard let view = hudView else { return }
        self.mode = mode
        
        // 如果视图隐藏，则设置框架并添加进度指示器
        if isHidden {
            frame = view.frame
            progressIndicator = LCProgressIndicatorLayer(size: LCProgressHUD.shared.spinnerSize, color: LCProgressHUD.shared.style.foregroundColor)
            view.addSubview(self)
        }
        
        // 设置进度指示器
        setupProgressIndicator()
        setStatus(status)
        show(true)
    }
    
    
    /// `显示`LCProgressHUD
    private func show(_ animated: Bool) {
        // 发送将要出现的通知
        NotificationCenter.default.post(name: LCProgressHUD.willAppear, object: self)

        // 设置是否使用动画
        useAnimation = animated
        // 设置需要重绘
        needsDisplay = true
        // 设置不隐藏
        isHidden = false

        if animated {
            DispatchQueue.main.async {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.20
                    self.animator().alphaValue = 1.0
                }, completionHandler: {
                    // 发送已经出现的通知
                    NotificationCenter.default.post(name: LCProgressHUD.didAppear, object: self)
                })
            }
        } else {
            alphaValue = 1.0
            // 发送已经出现的通知
            NotificationCenter.default.post(name: LCProgressHUD.didAppear, object: self)
        }
    }
    
    /// 隐藏LCProgressHUD视图，支持动画效果
    private func hide(_ animated: Bool) {
        // 如果已经隐藏，则不再执行
        guard !isHidden else { return }

        // 发送HUD即将消失的通知，通知其他部分准备
        NotificationCenter.default.post(name: LCProgressHUD.willDisappear, object: self)
        
        // 设置是否使用动画
        useAnimation = animated
        
        // 取消之前的所有待执行操作，避免重复触发
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        // 如果使用动画，则执行淡出动画
        if animated {
            // 使用淡出效果
            NSAnimationContext.beginGrouping()
            // 设置动画时长为0.20秒
            NSAnimationContext.current.duration = 0.20
            // 动画完成后的回调，执行done()方法
            NSAnimationContext.current.completionHandler = { [weak self] in
                self?.done()    // 完成隐藏后的操作
            }
            // 设置透明度动画效果
            animator().alphaValue = 0
            // 提交动画
            NSAnimationContext.endGrouping()
        } else {
            // 如果不使用动画，直接设置透明度为0
            alphaValue = 0.0
            // 直接执行完成操作
            done()
        }
    }
    
    
    
    /// 显示`带有进度`和`状态文本`的LCProgressHUD
    /// - Parameters:
    ///   - progress: 进度值，范围在0.0到1.0之间
    ///   - status: 状态信息，显示在LCProgressHUD上
    private func show(progress: Double, status: String) {
        // 显示具有确定模式的LCProgressHUD
        show(withStatus: status, mode: .determinate)
        // 设置进度
        self.progress = progress
    }
    
    /// 完成LCProgressHUD的显示
    private func done() {
        // 如果已经隐藏，则不再执行, 避免重复执行
        guard !isHidden else { return }
        progressIndicator.stopProgressAnimation()    // 停止进度动画
        alphaValue = 0.0        // 设置透明度为0
        isHidden = true         // 设置：隐藏
        // 如果当前视图有父视图，则从父视图中移除当前视图
        if superview != nil {
            removeFromSuperview()
        }
        completionHandler?()    // 执行完成后的回调
        // 如果指示器的父视图存在，则移除指示器
        if indicator?.superview != nil {
            indicator?.removeFromSuperview()
        }
        indicator = nil             // 释放指示器
        statusLabel.string = ""     // 清空状态标签
        // 如果窗口控制器的窗口可见，关闭窗口控制器
        if windowController?.window?.isVisible == true {
            windowController?.close()   // 关闭窗口控制器
        }
        
        // **始终执行 dismissCompletion 回调**
        dismissCompletion?()
        dismissCompletion = nil // 避免重复调用
        
        // 发送已经消失的通知
        NotificationCenter.default.post(name: LCProgressHUD.didDisappear, object: self)
    }
    
    
    
    /// 设置状态
    /// - Parameter status: 要显示的状态信息
    private func setStatus(_ status: String) {
        // 设置状态标签的颜色
        statusLabel.textColor = style.foregroundColor
        // 设置状态标签的字体
        statusLabel.font = font
        // 设置状态标签的文本
        statusLabel.string = status
        // 根据状态标签的文本内容自动调整标签的大小
        statusLabel.sizeToFit()
    }

    
    /// 处理鼠标点击事件
    /// - Parameter theEvent: 鼠标事件
    public override func mouseDown(with theEvent: NSEvent) {
        
        // 发送鼠标点击事件的通知
        NotificationCenter.default.post(name: LCProgressHUD.didReceiveMouseDownEvent, object: self)

        // 根据蒙版类型进行处理
        switch maskType {
        case .none:
            // 如果没有蒙版，让父类处理鼠标点击事件
            super.mouseDown(with: theEvent)
        default:
            // 其他情况不处理
            break
        }
        // 如果LCProgressHUD是可以被消除的
        if dismissible {
            // 在主线程中隐藏LCProgressHUD
            DispatchQueue.main.async {
                self.hide(self.useAnimation)
            }
        }
    }
    
    
    /// 设置进度指示器
    private func setupProgressIndicator() {
        // 根据模式进行设置
        switch mode {
        case .indeterminate:
            // 如果是不确定模式，使用一个旋转的指示器
            indicator?.removeFromSuperview()
            let view = NSView(frame: NSRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize))
            view.wantsLayer = true
            progressIndicator.startProgressAnimation()
            view.layer?.addSublayer(progressIndicator)
            indicator = view
            addSubview(indicator!)
        case .determinate, .text:
            // 如果是确定模式或者其他模式，不需要指示器
            indicator?.removeFromSuperview()
            indicator = nil
            
            // 如果是成功、错误、自定义带参数的模式，使用传入的view作为指示器
        case let .success(view), let .error(view), let .info(view) ,let .custom(view):
            indicator?.removeFromSuperview()
            indicator = view
            addSubview(indicator!)
        }
    }
    
    
    /// 延时隐藏LCProgressHUD
    /// - Parameter animated: 是否使用动画隐藏
    @objc private func hideDelayed(_ animated: NSNumber?) {
        // 取消之前的延时操作
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // 隐藏LCProgressHUD
        hide((animated != 0))
    }

    /// 根据字符串长度计算显示时长
    /// - Parameter string: 要显示的字符串
    /// - Returns: 显示的时长
    private func displayDuration(for string: String) -> TimeInterval {
        // 根据字符串的长度计算最小显示时长，至少显示0.5秒，每增加一个字符，增加0.06秒
        let minimum = max(TimeInterval(string.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        // 显示时长不能超过最大时长
        return min(minimum, maximumDismissTimeInterval)
    }
    
    

    // MARK: - Layout & Drawing

    func layoutSubviews() {

        // 完全覆盖父视图
        frame = superview?.bounds ?? .zero

        // 确定所需的总宽度和高度
        let maxWidth = bounds.size.width - margin * 4
        var totalSize = CGSize.zero
        var indicatorFrame = indicator?.bounds ?? .zero
        switch mode {
        case .determinate, .info, .success, .error: indicatorFrame.size.height = spinnerSize
        default: break
        }
        indicatorFrame.size.width = min(indicatorFrame.size.width, maxWidth)
        totalSize.width = max(totalSize.width, indicatorFrame.size.width)
        totalSize.height += indicatorFrame.size.height
        if indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }

        var statusLabelSize: CGSize = statusLabel.string.count > 0 ? statusLabel.string.size(withAttributes: [NSAttributedString.Key.font: statusLabel.font!]) : CGSize.zero
        if statusLabelSize.width > 0.0 {
            statusLabelSize.width += 10.0
        }
        statusLabelSize.width = min(statusLabelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, statusLabelSize.width)
        totalSize.height += statusLabelSize.height
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }
        totalSize.width += margin * 2
        totalSize.height += margin * 2

        // 位置
        var yPos = round((bounds.size.height - totalSize.height) / 2) + margin - yOffset
        if indicatorFrame.size.height > 0.0 {
            yPos += padding
        }
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos += padding + statusLabelSize.height
        }
        let xPos: CGFloat = 0
        indicatorFrame.origin.y = yPos
        // X值
        indicatorFrame.origin.x = round((bounds.size.width - indicatorFrame.size.width) / 2) + xPos
        indicator?.frame = indicatorFrame

        if indicatorFrame.size.height > 0.0 {
            yPos -= padding * 2
        }

        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos -= padding + statusLabelSize.height
        }
        var statusLabelFrame = CGRect.zero
        statusLabelFrame.origin.y = yPos
        statusLabelFrame.origin.x = round((bounds.size.width - statusLabelSize.width) / 2) + xPos
        statusLabelFrame.size = statusLabelSize
        statusLabel.frame = statusLabelFrame

        size = totalSize
    }

    public override func draw(_ rect: NSRect) {
        layoutSubviews()
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        switch maskType {
        case .black:
            context.setFillColor(NSColor.black.withAlphaComponent(0.6).cgColor)
            rect.fill()
        case let .custom(color):
            context.setFillColor(color.cgColor)
            rect.fill()
        default:
            break
        }
        
        // 设置矩形背景颜色
        context.setFillColor(style.backgroundColor.withAlphaComponent(opacity).cgColor)

        // 中心HUD
        let allRect = bounds

        // 绘制圆角HUD背景矩形
        let boxRect = CGRect(x: round((allRect.size.width - size.width) / 2),
                             y: round((allRect.size.height - size.height) / 2) - yOffset,
                             width: size.width, height: size.height)
        let radius = cornerRadius
        context.beginPath()
        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY))
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.maxY - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.maxY - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: false)
        context.closePath()
        context.fillPath()

/*
        let center = CGPoint(x: boxRect.origin.x + boxRect.size.width / 2, y: boxRect.origin.y + boxRect.size.height - spinnerSize * 0.9)
        switch mode {
        case .determinate:

            // 绘制确定的进度
            let lineWidth: CGFloat = 4.0
            let processBackgroundPath = NSBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .round

            let radius = spinnerSize / 2
            let startAngle: CGFloat = 90
            var endAngle = startAngle - 360 * CGFloat(progress)
            processBackgroundPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            context.setStrokeColor(style.foregroundColor.cgColor)
            processBackgroundPath.stroke()
            let processPath = NSBezierPath()
            processPath.lineCapStyle = .round
            processPath.lineWidth = lineWidth
            endAngle = startAngle - .pi * 2
            processPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            context.setFillColor(style.foregroundColor.cgColor)
            processPath.stroke()

        case .info:
            drawInfoSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        case .success:
            drawSuccessSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        case .error:
            drawErrorSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        default:
            break
        }
*/
        
        
        
        
        
        
        
        NSGraphicsContext.restoreGraphicsState()
    }

    
    /// 绘制信息符号
    /// - Parameter frame: 符号将在其中绘制的位置
    private func drawInfoSymbol(frame: NSRect) {
 
        /// 一般声明
        // 这个非泛型函数极大地缩短了复杂表达式的编译时间。
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

        /// 椭圆形绘图
        let ovalPath = NSBezierPath(ovalIn: NSRect(x: frame.minX + fastFloor((frame.width - 58) * 0.50000 + 0.5), y: frame.minY + fastFloor((frame.height - 58) * 0.50000 + 0.5), width: 58, height: 58))
        style.foregroundColor.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()

        /// 文字绘制
        let textPath = NSBezierPath()
        textPath.move(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 10.28))
        textPath.curve(to: NSPoint(x: frame.minX + 32.05, y: frame.maxY - 11), controlPoint1: NSPoint(x: frame.minX + 30.99, y: frame.maxY - 10.28), controlPoint2: NSPoint(x: frame.minX + 31.57, y: frame.maxY - 10.52))
        textPath.curve(to: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 12.75), controlPoint1: NSPoint(x: frame.minX + 32.53, y: frame.maxY - 11.48), controlPoint2: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 12.07))
        textPath.curve(to: NSPoint(x: frame.minX + 32.05, y: frame.maxY - 14.51), controlPoint1: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 13.43), controlPoint2: NSPoint(x: frame.minX + 32.53, y: frame.maxY - 14.02))
        textPath.curve(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 15.24), controlPoint1: NSPoint(x: frame.minX + 31.57, y: frame.maxY - 15), controlPoint2: NSPoint(x: frame.minX + 30.99, y: frame.maxY - 15.24))
        textPath.curve(to: NSPoint(x: frame.minX + 28.55, y: frame.maxY - 14.51), controlPoint1: NSPoint(x: frame.minX + 29.62, y: frame.maxY - 15.24), controlPoint2: NSPoint(x: frame.minX + 29.04, y: frame.maxY - 15))
        textPath.curve(to: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 12.75), controlPoint1: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 14.02), controlPoint2: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 13.43))
        textPath.curve(to: NSPoint(x: frame.minX + 28.54, y: frame.maxY - 11), controlPoint1: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 12.07), controlPoint2: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 11.48))
        textPath.curve(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 10.28), controlPoint1: NSPoint(x: frame.minX + 29.02, y: frame.maxY - 10.52), controlPoint2: NSPoint(x: frame.minX + 29.61, y: frame.maxY - 10.28))
        textPath.close()
        textPath.move(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 21.98))
        textPath.line(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 39.95))
        textPath.curve(to: NSPoint(x: frame.minX + 32.64, y: frame.maxY - 42.74), controlPoint1: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 41.35), controlPoint2: NSPoint(x: frame.minX + 32.43, y: frame.maxY - 42.28))
        textPath.curve(to: NSPoint(x: frame.minX + 33.54, y: frame.maxY - 43.78), controlPoint1: NSPoint(x: frame.minX + 32.84, y: frame.maxY - 43.21), controlPoint2: NSPoint(x: frame.minX + 33.14, y: frame.maxY - 43.55))
        textPath.curve(to: NSPoint(x: frame.minX + 35.73, y: frame.maxY - 44.12), controlPoint1: NSPoint(x: frame.minX + 33.94, y: frame.maxY - 44.01), controlPoint2: NSPoint(x: frame.minX + 34.67, y: frame.maxY - 44.12))
        textPath.line(to: NSPoint(x: frame.minX + 35.73, y: frame.maxY - 45))
        textPath.line(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 45))
        textPath.line(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 44.12))
        textPath.curve(to: NSPoint(x: frame.minX + 27.06, y: frame.maxY - 43.8), controlPoint1: NSPoint(x: frame.minX + 25.95, y: frame.maxY - 44.12), controlPoint2: NSPoint(x: frame.minX + 26.68, y: frame.maxY - 44.02))
        textPath.curve(to: NSPoint(x: frame.minX + 27.95, y: frame.maxY - 42.75), controlPoint1: NSPoint(x: frame.minX + 27.43, y: frame.maxY - 43.59), controlPoint2: NSPoint(x: frame.minX + 27.73, y: frame.maxY - 43.24))
        textPath.curve(to: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 39.95), controlPoint1: NSPoint(x: frame.minX + 28.17, y: frame.maxY - 42.27), controlPoint2: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 41.33))
        textPath.line(to: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 31.33))
        textPath.curve(to: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 26.62), controlPoint1: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 28.9), controlPoint2: NSPoint(x: frame.minX + 28.21, y: frame.maxY - 27.33))
        textPath.curve(to: NSPoint(x: frame.minX + 27.52, y: frame.maxY - 25.53), controlPoint1: NSPoint(x: frame.minX + 27.95, y: frame.maxY - 26.1), controlPoint2: NSPoint(x: frame.minX + 27.77, y: frame.maxY - 25.73))
        textPath.curve(to: NSPoint(x: frame.minX + 26.52, y: frame.maxY - 25.22), controlPoint1: NSPoint(x: frame.minX + 27.28, y: frame.maxY - 25.33), controlPoint2: NSPoint(x: frame.minX + 26.94, y: frame.maxY - 25.22))
        textPath.curve(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 25.59), controlPoint1: NSPoint(x: frame.minX + 26.07, y: frame.maxY - 25.22), controlPoint2: NSPoint(x: frame.minX + 25.51, y: frame.maxY - 25.35))
        textPath.line(to: NSPoint(x: frame.minX + 24.52, y: frame.maxY - 24.71))
        textPath.line(to: NSPoint(x: frame.minX + 31.26, y: frame.maxY - 21.98))
        textPath.line(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 21.98))
        textPath.close()
        style.foregroundColor.setFill()
        textPath.fill()
    }

    /// 绘制`成功符号`的方法
    ///
    /// - Parameter frame: 符号将在其中绘制的位置
    private func drawSuccessSymbol(frame: NSRect) {
        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: frame.minX + 0.05833 * frame.width, y: frame.minY + 0.48377 * frame.height))
        bezierPath.line(to: NSPoint(x: frame.minX + 0.31429 * frame.width, y: frame.minY + 0.19167 * frame.height))
        bezierPath.line(to: NSPoint(x: frame.minX + 0.93333 * frame.width, y: frame.minY + 0.80833 * frame.height))
        style.foregroundColor.setStroke()
        bezierPath.lineWidth = 4
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
    }
    
    /// 绘制`错误符号`的方法
    ///
    /// - Parameter frame: 符号将在其中绘制的位置
    private func drawErrorSymbol(frame: NSRect) {
        let bezier3Path = NSBezierPath()
        bezier3Path.move(to: NSPoint(x: frame.minX + 8, y: frame.maxY - 52))
        bezier3Path.line(to: NSPoint(x: frame.minX + 52, y: frame.maxY - 8))
        bezier3Path.move(to: NSPoint(x: frame.minX + 52, y: frame.maxY - 52))
        bezier3Path.line(to: NSPoint(x: frame.minX + 8, y: frame.maxY - 8))
        style.foregroundColor.setStroke()
        bezier3Path.lineWidth = 4
        bezier3Path.stroke()
    }

    // MARK: - Notifications

    static let didReceiveMouseDownEvent = Notification.Name("LCProgressHUD.didReceiveMouseDownEvent")
    static let willDisappear = Notification.Name("LCProgressHUD.willDisappear")
    static let didDisappear = Notification.Name("LCProgressHUD.didDisappear")
    static let willAppear = Notification.Name("LCProgressHUD.willAppear")
    static let didAppear = Notification.Name("LCProgressHUD.didAppear")

}
