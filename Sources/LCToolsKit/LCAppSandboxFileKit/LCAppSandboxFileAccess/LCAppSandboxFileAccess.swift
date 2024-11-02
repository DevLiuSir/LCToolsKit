//
//  LCAppSandboxFileAccess.swift
//  IPSWLibrary
//
//  Created by DevLiuSir on 2019/12/20.
//


import Foundation
import AppKit
import Cocoa


// 定义两个类型别名，表示`文件访问时`的`闭包`类型

/// 表示在应用沙盒中进行文件访问时的闭包类型
typealias LCAppSandboxFileAccessBlock = () -> Void

/// 表示在`应用沙盒`中进行带有`安全范围`的`文件访问时`的`闭包类型`
typealias AppSandboxFileSecurityScopeBlock = (_ securityScopedFileURL: URL, _ bookmarkData: Data?) -> Void



/// 本地化字符串的函数
/// - Parameter key: 要本地化的字符串键
/// - Returns: 对应的本地化字符串，如果未找到则返回原始键
func LCFileAccessLocalizeString(_ key: String) -> String {
    // 使用静态变量以确保只创建一次
    var bundle: Bundle?
    var onceToken: Int = 0
    
    // 确保线程安全
    // 检查一次标记以防止多次创建
    if onceToken == 0 {
        onceToken = 1
        // 获取LCAppSandboxFileKit的bundle
        bundle = Bundle(for: LCAppSandboxFileKit.self)
    }
    
    // 使用指定的键从bundle中获取本地化字符串
    // 如果未找到，返回原始键
    return bundle?.localizedString(forKey: key, value: "", table: "LCAppSandboxFileKit") ?? key
}


/// 应用程序的显示名称
let kAPP_Name: String = {
    // 获取主应用程序的 Bundle
    let mainBundle = Bundle.main
    
    // 尝试从不同的字典中获取应用程序的显示名称
    let appName = mainBundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
        ?? mainBundle.infoDictionary?["CFBundleDisplayName"] as? String
        ?? mainBundle.localizedInfoDictionary?["CFBundleName"] as? String
        ?? mainBundle.infoDictionary?["CFBundleName"] as? String

    // 如果所有方法都未能获取到应用程序名称，则返回默认值
    return appName ?? "默认应用程序名称" // 提供一个默认值
}()



/// 应用程序`沙盒文件访问`
class LCAppSandboxFileAccess {
    
    /// 用于在访问文件时显示的`标题`
    var title: String = ""
    
    /// 在请求文件访问权限时显示的`消息`
    var message: String = ""
    
    /// 在请求文件访问权限时, 显示的`按钮文本`
    var prompt: String = ""
    
    /// 创建默认的委托对象，用于持久化书签数据到用户默认值
    var accessPersist = LCAppSandboxFileAccessPersist()
    
    /// 创建一个 LCAppSandboxFileAccess 对象
    static var fileAccess = LCAppSandboxFileAccess()
    
    /// 是否允许开启文件夹选择， 默认：false
    var canChooseDirectories: Bool = false
    
    
    
    // 初始化方法，设置默认值并创建默认的委托对象
    init() {
        title = LCFileAccessLocalizeString("alert.title")
        prompt = LCFileAccessLocalizeString("alert.button.allow")
        message = String(format: title, arguments: [kAPP_Name])
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
        let openPanelDelegate = LCAppSandboxFileAccessOpenSavePanelDelegate(fileURL: url, canChooseDirectories: canChooseDirectories)

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
        do {
            // 使用 try 关键字调用可能抛出错误的方法
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            // 如果成功获取书签数据，则将其保存
            accessPersist.setBookmarkData(bookmarkData, for: url)
            
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
        
        // 获取文件 URL 对应的书签数据
        let bookmarkData = accessPersist.bookmarkData(for: fileURL)
        
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
            accessPersist.clearBookmarkData(for: fileURL)
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

    
    /// 检查`给定的路径`的是否具有`访问权限`
    ///
    /// - Parameter path: 需要检查权限的文件路径
    /// - Returns: 是否具有访问权限
    public class func checkAccessForPath(_ path: String) -> Bool {
        if path.isEmpty {
            return false
        }
        let fileURL = URL(fileURLWithPath: path)
        return checkAccessForURL(with: fileURL)
    }
    
    
    /// 检查`给定的URL`的是否具有`访问权限`
    ///
    /// - Parameter fileUrl: 需要检查权限的文件 URL
    /// - Returns: 是否具有访问权限
    public class func checkAccessForURL(with fileUrl: URL?) -> Bool {
        // 确保传入的 URL 有效
        guard let fileUrl = fileUrl, !fileUrl.path.isEmpty else {
            print("\(#function) 传入的路径不正确")
            return false
        }

        let fileURL = fileUrl.standardized.resolvingSymlinksInPath()

        // 获取书签数据
        guard let bookmarkData = fileAccess.accessPersist.bookmarkData(for: fileURL) else {
            print("\(#function) 未找到书签数据: \(fileURL.path)")
            return false
        }

        // 尝试解析书签数据
        return resolveBookmarkData(bookmarkData, for: fileURL, using: fileAccess)
    }

    /// `解析`书签数据, 并`检查访问权限`
    ///
    /// - Parameter bookmarkData: 书签数据
    /// - Parameter fileURL: 需要检查权限的文件 URL
    /// - Parameter fileAccess: 文件访问对象
    /// - Returns: 是否具有访问权限
    private class func resolveBookmarkData(_ bookmarkData: Data, for fileURL: URL, using fileAccess: LCAppSandboxFileAccess) -> Bool {
        var bookmarkDataIsStale = false
        do {
            // 解析书签数据以获取安全访问的 URL
            let allowedURL = try URL(
                resolvingBookmarkData: bookmarkData,
                options: [.withSecurityScope, .withoutUI],
                relativeTo: nil,
                bookmarkDataIsStale: &bookmarkDataIsStale
            )

            // 检查书签数据是否过期
            if bookmarkDataIsStale {
                // 如果过期，清除旧的书签数据
                fileAccess.accessPersist.clearBookmarkData(for: fileURL)
                print("\(#function) 授权已过期：\(fileURL.path)")
                return false
            }

            // 尝试访问安全作用域资源
            if allowedURL.startAccessingSecurityScopedResource() {
                return true
            } else {
                print("\(#function) 无法访问安全范围资源：\(fileURL.path)")
                return false
            }

        } catch {
            // 捕获解析书签数据时的错误
            print("\(#function) 无法解析 bookmark 数据: \(error)")
            return false
        }
    }
    
    
    
    
    
}
