//
//  LCOpenPanelManager.swift
//
//  Created by DevLiuSir on 2019/3/20.
//

import Cocoa

/// `LCOpenPanelManager`
/// 用于封装 macOS 的 `NSOpenPanel`，简化面板的创建和配置。
/// 提供静态方法支持快速生成和回调处理用户选择的文件或目录。
public class LCOpenPanelManager {
    
    /// 创建并配置一个通用的 `NSOpenPanel`
    /// - Parameters:
    ///   - title: 面板标题
    ///   - message: 面板信息
    ///   - canChooseFiles: 是否允许选择文件
    ///   - canChooseDirectories: 是否允许选择文件夹
    ///   - allowsMultipleSelection: 是否允许多选
    ///   - allowedFileTypes: 允许的文件类型
    ///   - directoryURL: 默认打开的目录
    /// - Returns: 配置好的 `NSOpenPanel` 实例
    public static func createOpenPanel(title: String = "", message: String, canChooseFiles: Bool = true, canChooseDirectories: Bool = false, allowsMultipleSelection: Bool = false,
                                allowedFileTypes: [String]? = nil, directoryURL: URL? = nil) -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.title = title
        openPanel.message = message           // 要在NSOpenPanel对象顶部显示文本或指令
        openPanel.canChooseFiles = canChooseFiles
        openPanel.canChooseDirectories = canChooseDirectories
        openPanel.allowsMultipleSelection = allowsMultipleSelection
        openPanel.allowedFileTypes = allowedFileTypes
        openPanel.directoryURL = directoryURL
        
        // 默认配置
        openPanel.canCreateDirectories = false          // 是否允许用户创建目录。
        openPanel.isAccessoryViewDisclosed = false      // 一个布尔值，指示面板的附件视图是否可见。
        openPanel.showsHiddenFiles = false              // 是否显示隐藏文件
        openPanel.showsTagField = false                 // 是否显示“标记”字段。
        
        return openPanel
    }
    
    /// 显示 `NSOpenPanel` 并通过回调处理用户选择
    /// - Parameters:
    ///   - title: 面板标题
    ///   - canChooseFiles: 是否允许选择文件
    ///   - canChooseDirectories: 是否允许选择文件夹
    ///   - allowsMultipleSelection: 是否允许多选
    ///   - allowedFileTypes: 允许的文件类型
    ///   - directoryURL: 默认打开的目录
    ///   - completion: 处理用户选择的回调
    public static func showOpenPanel(title: String, canChooseFiles: Bool = true, canChooseDirectories: Bool = false, allowsMultipleSelection: Bool = false,
                              allowedFileTypes: [String]? = nil, directoryURL: URL? = nil, completion: @escaping ([URL]) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.title = title
        openPanel.canChooseFiles = canChooseFiles
        openPanel.canChooseDirectories = canChooseDirectories
        openPanel.allowsMultipleSelection = allowsMultipleSelection
        openPanel.allowedFileTypes = allowedFileTypes
        openPanel.directoryURL = directoryURL
        
        // 默认配置
        openPanel.canCreateDirectories = false          // 是否允许用户创建目录。
        openPanel.isAccessoryViewDisclosed = false      // 一个布尔值，指示面板的附件视图是否可见。
        openPanel.showsHiddenFiles = false               // 是否显示隐藏文件
        openPanel.showsTagField = false                  // 是否显示“标记”字段。
        
        if openPanel.runModal() == .OK {
            completion(openPanel.urls)
        }
    }
    
    
}
