//
//  NSMenu+Extension.swift
//
//  Created by DevLiuSir on 2023/3/20
//
import Cocoa


public extension NSMenu {
    
    /// 在当前菜单及其所有子菜单中递归查找指定 tag 的菜单项
    ///
    /// - Parameter tag: 要查找的菜单项 tag（整型标识符）
    /// - Returns: 找到的 `NSMenuItem`，如果未找到则返回 `nil`
    func itemRecursively(withTag tag: Int) -> NSMenuItem? {
        for item in items {
            // 如果当前菜单项的 tag 匹配，直接返回
            if item.tag == tag {
                return item
            }
            // 如果有子菜单，则递归查找
            if let submenu = item.submenu,
               let found = submenu.itemRecursively(withTag: tag) {
                return found
            }
        }
        // 所有子菜单中都未找到，返回 nil
        return nil
    }
    
    
    /// `弹出菜单`并使其`居中对齐`于`指定按钮`
    /// - Parameters:
    ///   - button: 用于确定弹出位置的按钮。
    ///   - containerView: 菜单所在的容器视图，通常是按钮的父视图。
    ///   - yOffset: 相对于按钮的垂直偏移量，默认值为 -6，用来微调菜单的垂直位置。
    func showCenteredMenu(to button: NSButton, in containerView: NSView, yOffset: CGFloat = -6) {
        // 确保容器视图的子视图已经布局
        containerView.layoutSubtreeIfNeeded()
        
        // 将按钮的 frame 从其父视图的坐标系转换到容器视图的坐标系
        let buttonFrame = button.superview?.convert(button.frame, to: containerView) ?? .zero
        
        // 计算菜单的 x 坐标，使菜单居中于按钮
        let menuX = buttonFrame.midX - self.size.width / 2
        
        // 计算菜单的 y 坐标，yOffset 控制菜单在按钮上方或下方的偏移
        let menuY = buttonFrame.minY + yOffset
        
        // 弹出菜单
        self.popUp(positioning: nil, at: NSPoint(x: menuX, y: menuY), in: containerView)
    }
    
    
    /// 向菜单中添加一个新的菜单项
    ///
    /// - Parameters:
    ///   - string: 菜单项的标题
    ///   - selector: 菜单项点击时触发的 Selector（可选）
    ///   - target: 响应 action 的对象（可选）
    ///   - tag: 菜单项的标识 tag（可选，默认为 -1）
    ///   - obj: 菜单项绑定的自定义对象，可通过 `representedObject` 获取（可选）
    ///   - stateOn: 是否设置为选中状态（默认 false，即未选中）
    ///   - enabled: 是否启用该菜单项（默认 true）
    func addItem(withTitle string: String, action selector: Selector? = nil,
                 target: AnyObject? = nil, tag: Int? = nil, obj: Any? = nil,
                 stateOn: Bool = false, enabled: Bool = true) {
        // 创建菜单项，绑定标题和点击事件
        let menuItem = NSMenuItem(title: string, action: selector, keyEquivalent: "")
        
        // 设置标识 tag（可用于查找菜单项）
        menuItem.tag = tag ?? -1
        
        // 绑定自定义对象，可在 action 中通过 representedObject 获取
        menuItem.representedObject = obj
        
        // 设置响应目标
        menuItem.target = target
        
        // 设置菜单项状态（选中或未选中）
        menuItem.state = stateOn ? .on : .off
        
        // 设置是否可点击
        menuItem.isEnabled = enabled
        
        // 添加菜单项到菜单中
        self.addItem(menuItem)
    }
    
}
