//
//
//
//  NSEvent+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//
import Cocoa


/// 用作关联对象的 key，用于存储 NSControl 的点击回调闭包
/// 使用 Objective-C runtime 的 objc_getAssociatedObject / objc_setAssociatedObject
/// 来动态给 NSControl 添加一个闭包属性
fileprivate var NSControlClickedHandlerKey = false


public extension NSControl {
    
    // MARK: - 点击回调属性
    
    /// 给 NSControl 添加点击回调闭包
    ///
    /// 使用示例：
    /// ```swift
    /// myButton.clickedHandler = { control in
    ///     print("按钮点击了: \(control)")
    /// }
    /// ```
    ///
    /// 当控件被点击时，会自动调用该闭包。
    var clickedHandler: ((NSControl) -> Void)? {
        get {
            // 使用 runtime 获取关联对象，即存储的闭包
            return objc_getAssociatedObject(self, &NSControlClickedHandlerKey) as? ((NSControl) -> Void)
        }
        set {
            // 使用 runtime 设置关联对象
            objc_setAssociatedObject(self, &NSControlClickedHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            // 将控件的 target 设置为自身
            target = self
            // 将控件的 action 指向扩展中定义的 controlClicked 方法
            action = #selector(controlClicked)
        }
    }
    
    // MARK: - 私有方法
    
    /// 控件被点击时触发的方法
    /// 调用 stored clickedHandler 闭包
    @objc private func controlClicked() {
        clickedHandler?(self)
    }
}
