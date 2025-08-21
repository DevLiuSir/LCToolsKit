//
//  NSAlert+Extension.swift
//
//  Created by DevLiuSir on 2021/3/2.
//


import Foundation
import AppKit

public extension NSAlert {
    
    /// 显示alert
    /// - Parameters:
    ///   - modalWindow: 要展示的目标window
    ///   - style: 警告框的样式
    ///   - title: 标题
    ///   - message: 显示内容
    ///   - accessoryView: 插入自定义的view
    ///   - buttons: 按钮，最多3个，从右到左，或者从上到下
    ///   - handler: 回调，返回点击按钮的序号
    class func show(for modalWindow: NSWindow? = nil, style: NSAlert.Style = .warning, title: String, message: String? = nil, accessoryView: NSView? = nil, buttons: [String], handler: @escaping (Int) -> Void) {
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = style
        if message != nil { alert.informativeText = message! }
        alert.accessoryView = accessoryView
        for btn in buttons {
            alert.addButton(withTitle: btn)
        }
        if modalWindow == nil {
            let response = alert.runModal()
            switch response {
            case .alertFirstButtonReturn:   handler(0)
            case .alertSecondButtonReturn:  handler(1)
            case .alertThirdButtonReturn:   handler(2)
            default: break
            }
        } else {
            alert.beginSheetModal(for: modalWindow!) { response in
                switch response {
                case .alertFirstButtonReturn:   handler(0)
                case .alertSecondButtonReturn:  handler(1)
                case .alertThirdButtonReturn:   handler(2)
                default: break
                }
            }
        }
    }
    
    /// 显示alert
    /// - Parameters:
    ///   - modalWindow: 要展示的目标window
    ///   - style: 警告框的样式
    ///   - title: 标题
    ///   - message: 显示内容
    ///   - accessoryView: 插入自定义的view
    ///   - checkbox: 插入suppressionButton，复选框
    ///   - buttons: 按钮，最多3个，从右到左，或者从上到下
    ///   - handler: 回调，返回点击按钮的序号，复选框的状态
    class func show(for modalWindow: NSWindow? = nil, style: NSAlert.Style = .warning, title: String, message: String?, accessoryView: NSView? = nil, checkbox: String, buttons: [String], handler: @escaping (Int, Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = style
        if message != nil { alert.informativeText = message! }
        alert.accessoryView = accessoryView
        alert.showsSuppressionButton = true
        alert.suppressionButton?.title = checkbox
        for btn in buttons {
            alert.addButton(withTitle: btn)
        }
        if modalWindow == nil {
            let response = alert.runModal()
            let state = alert.suppressionButton?.state == .on
            switch response {
            case .alertFirstButtonReturn:   handler(0, state)
            case .alertSecondButtonReturn:  handler(1, state)
            case .alertThirdButtonReturn:   handler(2, state)
            default: break
            }
        } else {
            alert.beginSheetModal(for: modalWindow!) { response in
                let state = alert.suppressionButton?.state == .on
                switch response {
                case .alertFirstButtonReturn:   handler(0, state)
                case .alertSecondButtonReturn:  handler(1, state)
                case .alertThirdButtonReturn:   handler(2, state)
                default: break
                }
            }
        }
    }
    
    
    /// 显示一个警告对话框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 显示内容
    ///   - accessoryView: 插入自定义的view
    ///   - buttons: 按钮，最多3个，从右到左，或者从上到下
    /// - Returns: 用户点击的按钮索引（0 表示第一个按钮，1 表示第二个按钮，2 表示第三个按钮，未匹配返回 -1）
    class func show(title: String, message: String?, accessoryView: NSView? = nil, buttons: [String]) -> Int {
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = .warning
        if message != nil { alert.informativeText = message! }
        alert.accessoryView = accessoryView
        for btn in buttons {
            alert.addButton(withTitle: btn)
        }
        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:   return 0
        case .alertSecondButtonReturn:  return 1
        case .alertThirdButtonReturn:   return 2
        default: break
        }
        return -1
    }
    
    
    
    /// 显示一个带复选框的警告对话框
    ///
    /// - Parameters:
    ///   - title: 对话框标题
    ///   - message: 显示的提示信息（可选）
    ///   - accessoryView: 需要插入到对话框中的自定义视图（可选）
    ///   - checkbox: 复选框文字（suppressionButton 的标题）
    ///   - buttons: 按钮标题数组，最多支持 3 个，排列顺序为从右到左（水平排列时）或从上到下（垂直排列时）
    ///
    /// - Returns: 一个元组 `(index, isChecked)`
    ///   - `index`: 用户点击的按钮索引（0 表示第一个按钮，1 表示第二个按钮，2 表示第三个按钮，未匹配返回 -1）
    ///   - `isChecked`: 复选框是否被选中
    class func show(title: String, message: String?, accessoryView: NSView? = nil, checkbox: String, buttons: [String]) -> (Int, Bool) {
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = .warning
        if message != nil { alert.informativeText = message! }
        alert.accessoryView = accessoryView
        alert.showsSuppressionButton = true
        alert.suppressionButton?.title = checkbox
        for btn in buttons {
            alert.addButton(withTitle: btn)
        }
        let response = alert.runModal()
        let state = alert.suppressionButton?.state == .on
        switch response {
        case .alertFirstButtonReturn:   return (0, state)
        case .alertSecondButtonReturn:  return (1, state)
        case .alertThirdButtonReturn:   return (2, state)
        default: break
        }
        return (-1, state)
    }
    
    
    
}
