//
//  NSAlert+Extension.swift
//
//  Created by DevLiuSir on 2023/3/2.
//


import Foundation
import AppKit

public extension NSAlert {
    
    /// 显示 alert
    /// - Parameters:
    ///   - modalWindow: 要展示的目标 window
    ///   - title: 标题
    ///   - message: 显示内容
    ///   - accessoryView: 插入自定义的 view
    ///   - buttons: 按钮，最多 3 个，从右到左，或者从上到下
    ///   - handler: 回调，返回点击按钮的序号
    class func show(for modalWindow: NSWindow? = nil, title: String, message: String? = nil, accessoryView: NSView? = nil,
                    buttons: [String], handler: @escaping (Int) -> Void) {
        let alert = createAlert(title: title, message: message, accessoryView: accessoryView, buttons: buttons)
        
        if let window = modalWindow {
            alert.beginSheetModal(for: window) { response in
                handler(handleResponse(response))
            }
        } else {
            handler(handleResponse(alert.runModal()))
        }
    }
    
    /// 显示带复选框的 alert
    /// - Parameters:
    ///   - modalWindow: 要展示的目标 window
    ///   - title: 标题
    ///   - message: 显示内容
    ///   - accessoryView: 插入自定义的 view
    ///   - checkbox: 插入 suppressionButton 复选框
    ///   - buttons: 按钮，最多 3 个，从右到左，或者从上到下
    ///   - handler: 回调，返回点击按钮的序号和复选框状态
    class func show(for modalWindow: NSWindow?,
                    title: String, message: String?, accessoryView: NSView? = nil,
                    checkbox: String, buttons: [String], handler: @escaping (Int, Bool) -> Void) {
        let alert = createAlert(title: title, message: message, accessoryView: accessoryView, buttons: buttons)
        alert.showsSuppressionButton = true
        alert.suppressionButton?.title = checkbox
        
        let handleAction: (NSApplication.ModalResponse) -> Void = { response in
            let state = alert.suppressionButton?.state == .on
            handler(handleResponse(response), state)
        }
        
        if let window = modalWindow {
            alert.beginSheetModal(for: window, completionHandler: handleAction)
        } else {
            handleAction(alert.runModal())
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// 创建通用的 `NSAlert` 对象
    private static func createAlert(title: String, message: String?, accessoryView: NSView?, buttons: [String]) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = title
        if let message = message {
            alert.informativeText = message
        }
        alert.accessoryView = accessoryView
        alert.alertStyle = .warning
        buttons.forEach { alert.addButton(withTitle: $0) }
        return alert
    }
    
    /// 处理 NSAlert 响应值并返回点击按钮的索引
    private static func handleResponse(_ response: NSApplication.ModalResponse) -> Int {
        switch response {
        case .alertFirstButtonReturn:  return 0
        case .alertSecondButtonReturn: return 1
        case .alertThirdButtonReturn:  return 2
        default: return -1
        }
    }
}
