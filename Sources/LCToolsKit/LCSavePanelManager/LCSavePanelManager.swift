//
//  LCSavePanelManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//
import Foundation
import AppKit


/// `LCSavePanelManager`
/// 用于封装 macOS 的 `NSSavePanel`，简化保存面板的创建和配置。
/// 提供静态方法支持快速生成和回调处理用户选择的保存路径
public class LCSavePanelManager {
    
    
    /// 选择保存路径
    /// - Parameters:
    ///   - modalWindow: 要显示到的window
    ///   - title: 标题
    ///   - message: 显示的信息
    ///   - prompt: 保存按钮
    ///   - nameFieldLabel: 保存的文件名的标题
    ///   - directoryURL: 目标路径
    ///   - nameFieldStringValue: 保存的文件名，modal 前有效
    ///   - canCreateDirectories: 是否可以创建文件夹
    ///   - canSelectHiddenExtension: 是否显示隐藏扩展菜单项
    ///   - showsHiddenFiles: 是否显示隐藏文件
    ///   - isExtensionHidden: 扩展名是否隐藏
    ///   - accessoryView: 自定义view
    ///   - identifier: 标识符
    ///   - handler: 异步回调
    /// - Returns: 返回 savePanel
    @discardableResult
    class func show(for modalWindow: NSWindow? = nil,
                    title: String? = nil,
                    message: String? = nil,
                    prompt: String? = nil,
                    nameFieldLabel: String? = nil,
                    directoryURL: URL? = nil,
                    nameFieldStringValue: String? = nil,
                    canCreateDirectories: Bool = true,
                    canSelectHiddenExtension: Bool = false,
                    showsHiddenFiles: Bool = false,
                    isExtensionHidden: Bool = true,
                    accessoryView: NSView? = nil,
                    identifier: NSUserInterfaceItemIdentifier? = nil,
                    handler: @escaping (NSApplication.ModalResponse, URL?) -> Void) -> NSSavePanel {
        let savePanel = NSSavePanel()
        if let title = title { savePanel.title = title }
        if let message = message { savePanel.message = message }
        if let prompt = prompt { savePanel.prompt = prompt }
        if let nameFieldLabel = nameFieldLabel { savePanel.nameFieldLabel = nameFieldLabel }
        if let nameFieldStringValue = nameFieldStringValue { savePanel.nameFieldStringValue = nameFieldStringValue }
        savePanel.directoryURL = directoryURL
        savePanel.canCreateDirectories = canCreateDirectories
        savePanel.canSelectHiddenExtension = canSelectHiddenExtension
        savePanel.isExtensionHidden = isExtensionHidden
        savePanel.showsHiddenFiles = showsHiddenFiles
        savePanel.accessoryView = accessoryView
        savePanel.identifier = identifier
        if let modalWindow = modalWindow {
            savePanel.beginSheetModal(for: modalWindow) { response in
                handler(response, savePanel.url)
            }
        } else {
            savePanel.begin { response in
                handler(response, savePanel.url)
            }
        }
        return savePanel
    }
    
    /// 选择保存路径
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 显示的信息
    ///   - prompt: 保存按钮
    ///   - nameFieldLabel: 保存的文件名的标题
    ///   - directoryURL: 目标路径
    ///   - nameFieldStringValue: 保存的文件名，modal 前有效
    ///   - canCreateDirectories: 是否可以创建文件夹
    ///   - canSelectHiddenExtension: 是否显示隐藏扩展菜单项
    ///   - showsHiddenFiles: 是否显示隐藏文件
    ///   - isExtensionHidden: 扩展名是否隐藏
    ///   - accessoryView: 自定义view
    ///   - identifier: 标识符
    /// - Returns: 返回选择的结果
    @discardableResult
    class func show(title: String? = nil,
                    message: String? = nil,
                    prompt: String? = nil,
                    nameFieldLabel: String? = nil,
                    directoryURL: URL? = nil,
                    nameFieldStringValue: String? = nil,
                    canCreateDirectories: Bool = true,
                    canSelectHiddenExtension: Bool = false,
                    showsHiddenFiles: Bool = false,
                    isExtensionHidden: Bool = true,
                    accessoryView: NSView? = nil,
                    identifier: NSUserInterfaceItemIdentifier? = nil) -> (NSApplication.ModalResponse, URL?) {
        let savePanel = NSSavePanel()
        if let title = title { savePanel.title = title }
        if let message = message { savePanel.message = message }
        if let prompt = prompt { savePanel.prompt = prompt }
        if let nameFieldLabel = nameFieldLabel { savePanel.nameFieldLabel = nameFieldLabel }
        if let nameFieldStringValue = nameFieldStringValue { savePanel.nameFieldStringValue = nameFieldStringValue }
        savePanel.directoryURL = directoryURL
        savePanel.canCreateDirectories = canCreateDirectories
        savePanel.canSelectHiddenExtension = canSelectHiddenExtension
        savePanel.isExtensionHidden = isExtensionHidden
        savePanel.showsHiddenFiles = showsHiddenFiles
        savePanel.accessoryView = accessoryView
        savePanel.identifier = identifier
        let response = savePanel.runModal()
        return (response, savePanel.url)
    }
}

