//
//
//  LCAppInfo.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Foundation
import Cocoa



/// App 信息工具类
public struct LCAppInfo {
    
    // MARK: - Public Methods
    
    /// 获取指定 App 的版本号
    /// - Parameters:
    ///   - bundleId: 应用 bundle identifier
    ///   - strict: 是否严格要求 App 必须在 `/Applications` 目录下，默认为 false
    /// - Returns: 返回 CFBundleShortVersionString，找不到则返回 nil
    public static func version(for bundleId: String, strict: Bool = false) -> String? {
        guard let bundle = bundle(for: bundleId, strict: strict) else { return nil }
        return bundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// 获取指定 App 的 Bundle Identifier
    /// - Parameters:
    ///   - bundleId: 应用 bundle identifier
    ///   - strict: 是否严格要求 App 必须在 `/Applications` 目录下，默认为 false
    /// - Returns: 返回 bundleIdentifier，如果找不到返回 nil
    public static func bundleIdentifier(for bundleId: String, strict: Bool = false) -> String? {
        return bundle(for: bundleId, strict: strict)?.bundleIdentifier
    }
    
    /// 获取指定 App 的图标
    /// - Parameters:
    ///   - bundleId: 应用 bundle identifier
    ///   - strict: 是否严格要求 App 必须在 `/Applications` 目录下，默认为 false
    /// - Returns: 返回 NSImage 图标，如果找不到返回 nil
    public static func icon(for bundleId: String, strict: Bool = false) -> NSImage? {
        guard let url = appUrl(bundleId, strict: strict) else { return nil }
        return NSWorkspace.shared.icon(forFile: url.path)
    }
    
    /// 获取指定 App 的文件 URL
    /// - Parameters:
    ///   - bundleId: 应用 bundle identifier
    ///   - strict: 是否严格要求 App 必须在 `/Applications` 目录下，默认为 false
    /// - Returns: 返回 App URL，如果未找到返回 nil
    public static func appUrl(_ bundleId: String, strict: Bool = false) -> URL? {
        if #available(macOS 12.0, *) {
            let urls = NSWorkspace.shared.urlsForApplications(withBundleIdentifier: bundleId)
            return urlsFilteredAndSorted(urls, strict: strict)
        } else if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) {
            return strict && !url.path.hasPrefix("/Applications") ? nil : url
        } else {
            return nil
        }
    }
    
    // MARK: - Private Helpers
    
    /// 获取 App 对应的 Bundle
    private static func bundle(for bundleId: String, strict: Bool) -> Bundle? {
        guard let url = appUrl(bundleId, strict: strict) else { return nil }
        return Bundle(url: url)
    }
    
    /// 过滤掉 Xcode 调试应用并按版本排序
    private static func urlsFilteredAndSorted(_ urls: [URL], strict: Bool) -> URL? {
        // 过滤掉 Xcode 下的应用
        let filtered = urls.filter { !$0.path.contains("/Library/Developer/Xcode/") }
        guard !filtered.isEmpty else { return nil }
        // 按 CFBundleShortVersionString 排序，最新版本优先
        let sorted = filtered.sorted { url1, url2 in
            let version1 = Bundle(url: url1)?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            let version2 = Bundle(url: url2)?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            return version1.compare(version2, options: .numeric) == .orderedDescending
        }
        if strict {
            return sorted.first(where: { $0.path.hasPrefix("/Applications") })
        } else {
            return sorted.first
        }
    }
    
}
