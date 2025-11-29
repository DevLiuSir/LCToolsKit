//
//  LCSystemVersionUtil.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation

/// 系统版本工具类，用于进行版本范围判断
public final class LCSystemVersionUtil {
    
    public enum MacOS: String {
        case mojave     // 10.14
        case catalina   // 10.15
        case bigSur     // 11
        case monterey   // 12
        case ventura    // 13
        case sonoma     // 14
        case sequoia    // 15
        case tahoe      // 26
    }
    
    public static var currentOS: MacOS {
        if #available(macOS 26, *) { return .tahoe }
        else if #available(macOS 15, *) { return .sequoia }
        else if #available(macOS 14, *) { return .sonoma }
        else if #available(macOS 13, *) { return .ventura }
        else if #available(macOS 12, *) { return .monterey }
        else if #available(macOS 11, *) { return .bigSur }
        else if #available(macOS 10.15, *) { return .catalina }
        else { return .mojave } // 最低版本直接用 else
    }
    
    
    /// 26.0 系统及以后
    public static let is26OrLater: Bool = { if #available(macOS 26.0, *) { true } else { false } }()
    
    
    /// 获取当前系统版本号（主版本号、次版本号、补丁号）
    ///
    /// - Returns: 当前系统版本号的三元组 `(major, minor, patch)`，例如 macOS 15.4.1 返回 `(15, 4, 1)`
    public static var currentVersion: (major: Int, minor: Int, patch: Int) {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return (v.majorVersion, v.minorVersion, v.patchVersion)
    }
    
    /// 判断当前系统版本是否处于`指定的闭区间范围内`（包含上下限）
    ///
    /// - Parameters:
    ///   - minVersion: 最小版本号，格式为三元组 `(major, minor, patch)`，例如 `(15, 0, 0)`
    ///   - maxVersion: 最大版本号，格式为三元组 `(major, minor, patch)`，例如 `(15, 4, 1)`
    ///
    /// - Returns: 如果当前版本在该范围内返回 `true`，否则返回 `false`
    public static func isCurrentVersion(minVersion: (Int, Int, Int), maxVersion: (Int, Int, Int)) -> Bool {
        let current = currentVersion
        return current >= minVersion && current <= maxVersion
    }
    
    /// 判断当前系统的主版本号是否`等于`指定版本
    ///
    /// - Parameter targetMajor: 目标主版本号，例如 macOS 14 则传入 `14`
    ///
    /// - Returns: 如果当前主版本号与目标相同，返回 `true`
    public static func isMajorVersion(_ targetMajor: Int) -> Bool {
        return currentVersion.major == targetMajor
    }
    
    
    /// 判断当前系统版本是否`等于`指定版本
    /// - Parameter versionString: 版本字符串，例如 "15.6.1"
    /// - Returns: 如果当前版本等于指定版本返回 true
    public static func isEqualTo(_ versionString: String) -> Bool {
        let components = versionString.split(separator: ".").map { Int($0) ?? 0 }
        let targetVersion: (Int, Int, Int) = (
            components.count > 0 ? components[0] : 0,
            components.count > 1 ? components[1] : 0,
            components.count > 2 ? components[2] : 0
        )
        return currentVersion == targetVersion
    }
    
    
    // MARK: - 常用扩展方法
    
    /// 判断当前版本是否`大于等于`指定版本
    public static func isAtLeast(_ versionString: String) -> Bool {
        return currentVersion >= parseVersion(versionString)
    }
    
    /// 判断当前版本是否小于等于指定版本
    public static func isAtMost(_ versionString: String) -> Bool {
        return currentVersion <= parseVersion(versionString)
    }
    
    /// 判断当前版本是否大于指定版本
    public static func isGreaterThan(_ versionString: String) -> Bool {
        return currentVersion > parseVersion(versionString)
    }
    
    /// 判断当前版本是否小于指定版本
    public static func isLessThan(_ versionString: String) -> Bool {
        return currentVersion < parseVersion(versionString)
    }
    
    /// 判断当前系统是否在某个大版本及以后
    /// - Parameter major: 目标主版本号，例如 macOS 15
    public static func isAtLeastMajor(_ major: Int) -> Bool {
        return currentVersion.major >= major
    }
    
    /// 将版本字符串（如 "15.6.1"）解析为 `(major, minor, patch)`
    private static func parseVersion(_ versionString: String) -> (Int, Int, Int) {
        let components = versionString.split(separator: ".").map { Int($0) ?? 0 }
        return (
            components.count > 0 ? components[0] : 0,
            components.count > 1 ? components[1] : 0,
            components.count > 2 ? components[2] : 0
        )
    }
    
    
    
}
