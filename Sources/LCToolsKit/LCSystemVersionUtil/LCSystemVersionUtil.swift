//
//  LCSystemVersionUtil.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation

/// 系统版本工具类，用于进行版本范围判断
public final class LCSystemVersionUtil {
    
    /// 获取当前系统版本号（主版本号、次版本号、补丁号）
    ///
    /// - Returns: 当前系统版本号的三元组 `(major, minor, patch)`，例如 macOS 15.4.1 返回 `(15, 4, 1)`
    public static var currentVersion: (major: Int, minor: Int, patch: Int) {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return (v.majorVersion, v.minorVersion, v.patchVersion)
    }
    
    /// 判断当前系统版本是否处于指定的闭区间范围内（包含上下限）
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
    
    /// 判断当前系统的主版本号是否等于指定版本
    ///
    /// - Parameter targetMajor: 目标主版本号，例如 macOS 14 则传入 `14`
    ///
    /// - Returns: 如果当前主版本号与目标相同，返回 `true`
    public static func isMajorVersion(_ targetMajor: Int) -> Bool {
        return currentVersion.major == targetMajor
    }
    
    
    /// 判断当前系统版本是否等于指定版本
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
    
}
