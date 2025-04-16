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
    
    
}
