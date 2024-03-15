//
//  LCAppSandboxFileAccess.swift
//  IPSWLibrary
//
//  Created by Liu Chuan on 2019/12/20.
//


import Foundation
import AppKit
import Cocoa


// 定义两个类型别名，表示`文件访问时`的`闭包`类型

/// 表示在应用沙盒中进行文件访问时的闭包类型
typealias LCAppSandboxFileAccessBlock = () -> Void

/// 表示在`应用沙盒`中进行带有`安全范围`的`文件访问时`的`闭包类型`
typealias AppSandboxFileSecurityScopeBlock = (_ securityScopedFileURL: URL, _ bookmarkData: Data?) -> Void


/// 应用程序`沙盒文件访问`
class LCAppSandboxFileAccess {
    
    
    /// 用于在访问文件时显示的标题
    var title: String = "Allow Access"
    
    /// 在请求文件访问权限时显示的消息
    var message: String = "App needs to access this path to continue. Please click Allow"
    
    /// 在请求文件访问权限时显示的按钮文本
    var prompt: String = "Allow"
    
    /// 可选的委托对象，用于自定义书签数据的持久化
    weak var bookmarkPersistanceDelegate: LCAppSandboxFileAccessProtocol?
    
    /// 创建默认的委托对象，用于持久化书签数据到用户默认值
    private var defaultDelegate: LCAppSandboxFileAccessPersist = LCAppSandboxFileAccessPersist()

    /// 类方法，用于创建一个 LCAppSandboxFileAccess 对象
    class func fileAccess() -> LCAppSandboxFileAccess {
        return LCAppSandboxFileAccess()
    }
    
    // 初始化方法，设置默认值并创建默认的委托对象
    init() {
        
        // 尝试通过框架的 bundle identifier 获取 框架 的Bundle对象
        guard let frameworkBundle = Bundle(identifier: "org.cocoapods.LCToolsKit") else {
            // 如果无法获取Bundle，直接返回
            return
        }

        // 使用获取到的Bundle对象来获取本地化的字符串
        // 这里的'alert.title'是本地化字符串的键
        // 'LCAppSandboxFileKit'是存储本地化字符串的.strings文件的名称（不含扩展名）
        let alertTitle = frameworkBundle.localizedString(forKey: "alert.title", value: nil, table: "LCAppSandboxFileKit")
        
        /// 应用程序名称
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        
        /// 本地化信息
        let formatString = alertTitle
        
        
        title = alertTitle
        
        /// 标题
        message = String(format: formatString, arguments: [bundleName])
        
        // 按钮
        prompt = frameworkBundle.localizedString(forKey: "alert.button.allow", value: nil, table: "LCAppSandboxFileKit")
        
        
        defaultDelegate = LCAppSandboxFileAccessPersist()

        bookmarkPersistanceDelegate = defaultDelegate
    }
    
    
    /// 请求文件访问权限的函数
    ///
    /// - Parameters:
    ///   - url: 需要请求访问权限的URL
    /// - Returns: 允许访问的URL，如果未选择则为nil
    private func askPermission(for url: URL) -> URL? {
        // 确保url参数不为空
        guard let url = url as URL? else {
            assertionFailure("URL不能为空")
            return nil
        }
        
        // 允许的URL，可能是传入URL的父URL
        var allowedURL: URL?

        // 创建OpenPanel委托以限制可以选择的文件
        // 确保只能选择一个文件夹或可以选择授予所请求文件权限的文件
        let openPanelDelegate = LCAppSandboxFileAccessOpenSavePanelDelegate(fileURL: url)

        // 检查url是否存在，如果不存在，找到存在的url的父路径并请求权限
        let fileManager = FileManager.default
        var path = url.path
        while path.count > 1 {  // 当路径中只剩下“/”或者到达一个存在的路径时放弃
            if fileManager.fileExists(atPath: path, isDirectory: nil) {
                break
            }
            path = (path as NSString).deletingLastPathComponent
        }
        let updatedURL = URL(fileURLWithPath: path)

        // 显示打开面板
        let displayOpenPanelBlock = {
            let openPanel = NSOpenPanel()
            openPanel.title = self.title
            openPanel.message = self.message            // 要在NSOpenPanel对象顶部显示文本或指令
            openPanel.prompt = self.prompt
            openPanel.canCreateDirectories = false       // 是否允许用户创建目录。
            openPanel.canChooseFiles = false             // 是否允许用户选择文件
            openPanel.canChooseDirectories = true        // 是否允许用户选择要打开的 文件夹
            openPanel.directoryURL = updatedURL
            openPanel.delegate = openPanelDelegate
            NSApp.activate(ignoringOtherApps: true)

            // 用户选择了文件夹后，更新allowedURL
            if openPanel.runModal() == NSApplication.ModalResponse.OK {
                allowedURL = openPanel.url
            }
        }

        // 在主线程上执行显示Open Panel的操作
        if Thread.isMainThread {
            displayOpenPanelBlock()
        } else {
            DispatchQueue.main.sync(execute: displayOpenPanelBlock)
        }

        return allowedURL
    }
    
    
    /// 用于`请求对文件路径`的访问权限，并执行相应的闭包
    ///
    /// - Parameters:
    ///   - path: 文件的路径
    ///   - persist: 是否持久化权限
    ///   - completion: 执行的闭包，接受一个布尔值参数，表示是否获得了权限
    /// - Returns: 是否成功发起权限请求
    func accessFilePath(_ path: String, persistPermission persist: Bool, withCompletion completion: @escaping LCAppSandboxFileAccessBlock) -> Bool {
        return accessFileURL(URL(fileURLWithPath: path), persistPermission: persist, withCompletion: completion)
    }
    
    
    /// 用于`请求对文件 URL` 的访问权限，并执行相应的闭包
    ///
    /// - Parameters:
    ///   - fileURL: 文件的 URL
    ///   - persist: 是否持久化权限
    ///   - completion: 执行的闭包，表示是否获得了权限
    /// - Returns: 是否成功发起权限请求
    private func accessFileURL(_ fileURL: URL, persistPermission persist: Bool, withCompletion completion: @escaping LCAppSandboxFileAccessBlock) -> Bool {
        // 确保 bookmarkPersistanceDelegate 不为 nil
        guard bookmarkPersistanceDelegate != nil else {
            return false
        }
        
        // 默认权限请求状态为失败
        var success = false
        
        // 请求文件访问权限
        success = requestAccessPermissions(forFileURL: fileURL, persistPermission: persist) { securityScopedFileURL, bookmarkData in
            // 开始访问安全作用域资源
            _ = securityScopedFileURL.startAccessingSecurityScopedResource()
            
            // 执行具有文件访问权限的闭包
            completion()
            
            // 停止访问安全作用域资源
            securityScopedFileURL.stopAccessingSecurityScopedResource()
        }
        
        // 返回权限请求的结果
        return success
    }
    
    
    
    /// 请求对`文件路径`的访问权限，并执行相应的闭包。
    ///
    /// - Parameters:
    ///   - filePath: 要`请求权限`的`文件路径`。
    ///   - persist: 是否持久化文件访问权限。
    ///   - block: 文件访问权限获得后执行的闭包。
    /// - Returns: 是否成功请求文件访问权限。
    private func requestAccessPermissions(forFilePath filePath: String, persistPermission persist: Bool, withBlock block: @escaping AppSandboxFileSecurityScopeBlock) -> Bool {
        return requestAccessPermissions(forFileURL: URL(fileURLWithPath: filePath), persistPermission: persist, withCompletion: block)
    }

    
    
    /// 持久化文件访问权限的书签数据，返回书签数据。
    ///
    /// - Parameters:
    ///   - url: 要持久化权限的URL。
    /// - Returns: 持久化的书签数据，如果发生错误则返回nil。
    private func persistPermissionURL(_ url: URL) -> Data? {
        // 检查是否有有效的委托
        guard let bookmarkPersistanceDelegate = bookmarkPersistanceDelegate else {
            return nil
        }
        
        do {
            // 使用 try 关键字调用可能抛出错误的方法
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            // 如果成功获取书签数据，则将其保存
            bookmarkPersistanceDelegate.setBookmarkData(bookmarkData, for: url)
            
            return bookmarkData
        } catch {
            // 处理错误，这里可以根据需要进行具体处理
            print("Error persisting bookmark data: \(error)")
            return nil
        }
    }
    
    
    /// 请求对文件 URL 的访问权限，并执行相应的闭包
    ///
    /// - Parameters:
    ///   - fileURL: 文件的 URL
    ///   - persist: 是否持久化权限
    ///   - completion: 执行的闭包，接受允许访问的 URL 和相关的书签数据
    /// - Returns: 是否成功发起权限请求
    private func requestAccessPermissions(forFileURL fileURL: URL, persistPermission persist: Bool, withCompletion completion: @escaping AppSandboxFileSecurityScopeBlock) -> Bool {
        // 确保 bookmarkPersistanceDelegate 不为 nil
        guard let bookmarkPersistanceDelegate = bookmarkPersistanceDelegate else {
            return false
        }

        // 获取文件 URL 对应的书签数据
        let bookmarkData = bookmarkPersistanceDelegate.bookmarkData(for: fileURL)
        
        // 尝试获取允许访问的 URL
        var allowedURL = resolveAllowedURL(fromBookmarkData: bookmarkData, forFileURL: fileURL, persistPermission: persist)

        // 如果没有有效的允许访问的 URL，请求用户权限
        if allowedURL == nil {
            allowedURL = askPermission(for: fileURL)
            if allowedURL == nil {
                return false
            }
        }

        // 如果需要持久化权限，并且之前没有书签数据，则进行持久化
        persistPermissionIfNeeded(forURL: allowedURL, shouldPersist: persist)

        // 执行传入的闭包，将允许访问的 URL 和相关的书签数据传递给闭包
        completion(allowedURL!, bookmarkData)
        return true
    }

    
    /// 通过书签数据解析得到允许访问的 URL
    ///
    /// - Parameters:
    ///   - bookmarkData: 文件 URL 对应的书签数据
    ///   - fileURL: 文件 URL
    ///   - persist: 是否持久化权限
    /// - Returns: 解析得到的允许访问的 URL
    private func resolveAllowedURL(fromBookmarkData bookmarkData: Data?, forFileURL fileURL: URL, persistPermission persist: Bool) -> URL? {
        // 如果书签数据为空，则返回 nil
        guard let bookmarkData = bookmarkData else {
            return nil
        }

        var bookmarkDataIsStale = false
        // 通过书签数据解析得到允许访问的 URL
        var allowedURL = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)

        // 如果书签数据已经过期，清除该书签数据，并在需要持久化权限时重新持久化
        if bookmarkDataIsStale {
            bookmarkPersistanceDelegate?.clearBookmarkData(for: fileURL)
            allowedURL = allowedURL.flatMap { persistPermissionURL($0) }.flatMap { URL(dataRepresentation: $0, relativeTo: nil) }
        }
        
        return allowedURL
    }

    
    
    /// 如果需要持久化权限，进行持久化
    ///
    /// - Parameters:
    ///   - url: 需要持久化权限的 URL
    ///   - persist: 是否需要持久化权限
    private func persistPermissionIfNeeded(forURL url: URL?, shouldPersist persist: Bool) {
        // 如果 URL 为空或者不需要持久化权限，则直接返回
        guard let url = url, persist else {
            return
        }

        // 执行持久化权限的操作
        _ = persistPermissionURL(url)
    }

    


}
