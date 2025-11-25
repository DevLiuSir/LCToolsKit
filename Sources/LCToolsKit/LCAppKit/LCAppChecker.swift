//
//
//  LCAppChecker.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Cocoa

/// App 检查工具类
public struct LCAppChecker {
    
    /// 检查`指定 App` 是否`正在运行`
    /// - Parameter bundleIds: 单个或多个应用的 Bundle Identifier
    /// - Returns: 如果任意指定的应用正在运行，则返回 true，否则返回 false
    public static func isAppRunning(_ bundleIds: [String]) -> Bool {
        for id in bundleIds {
            if !NSRunningApplication.runningApplications(withBundleIdentifier: id).isEmpty {
                return true     // 找到匹配的应用程序，返回 true
            }
        }
        return false    // 如果未找到符合条件的应用程序，返回 false
    }
    
    /// 判断 App 是否安装
    /// - Parameters:
    ///   - bundleId: 应用 bundle identifier
    ///   - strict: 是否严格要求在 /Applications 目录，默认为 true
    /// - Returns: 是否安装
    public static func isAppInstalled(_ bundleId: String, strict: Bool = true) -> Bool {
        guard let url = appUrl(bundleId, strict: strict) else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    
    /// 获取指定 App 的路径
    /// - Parameters:
    ///   - bundleId: 应用的 Bundle Identifier，用于唯一标识应用
    ///   - strict: 是否严格要求 App 必须在 `/Applications` 目录下，默认为 true
    /// - Returns: 返回符合条件的 App URL，如果未找到则返回 nil
    public static func appUrl(_ bundleId: String, strict: Bool = true) -> URL? {
        // 1、获取所有匹配指定 bundleId 的应用程序 URL
        let urls: [URL]
        if #available(macOS 12.0, *) {
            urls = NSWorkspace.shared.urlsForApplications(withBundleIdentifier: bundleId)
        } else if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) {
            urls = [url]
        } else {
            // 未找到任何应用，直接返回 nil
            return nil
        }
        
        // 2、过滤掉 Xcode 下的调试应用，避免误选
        let filtered = filterOutXcodeApps(urls)
        guard !filtered.isEmpty else { return nil }
        
        // 3、按 CFBundleShortVersionString 排序，最新版本优先
        let sorted = sortAppsByVersion(filtered)
        
        // 4、根据 strict 参数决定返回哪一个 URL
        if strict {
            // 严格模式：只返回 /Applications 下的应用
            return sorted.first(where: { $0.path.hasPrefix("/Applications") })
        } else {
            // 非严格模式：返回最新版本，无论路径
            return sorted.first
        }
    }
    
    
    // MARK: - Private helpers
    
    /// 过滤掉 Xcode 下的应用
    private static func filterOutXcodeApps(_ urls: [URL]) -> [URL] {
        urls.filter { !$0.path.contains("/Library/Developer/Xcode/") }
    }
    
    /// 按 CFBundleShortVersionString 排序，最新版本优先
    /// - Parameter urls: 应用程序 URL 数组，通常经过过滤的列表
    /// - Returns: 按版本号降序排列的应用 URL 数组，最新版本排在前面
    private static func sortAppsByVersion(_ urls: [URL]) -> [URL] {
        urls.sorted { url1, url2 in
            let version1 = Bundle(url: url1)?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            let version2 = Bundle(url: url2)?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            return version1.compare(version2, options: .numeric) == .orderedDescending
        }
    }
    
}
