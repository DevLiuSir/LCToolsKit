//
//  LCLoginItemManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa
import ServiceManagement


/// 自动启动提醒管理器
public class LCLoginItemManager {
    
    /// 单例
    public static let shared = LCLoginItemManager()
    
    private init() {}
   
    /// 设置 `开机自启动` 应用程序。
    ///
    /// - Parameters:
    ///   - enabled: 指定是否启用随系统启动。
    ///   - bundleID: Helper App 的 Bundle Identifier。
    public static func setLaunchAtLogin(_ enabled: Bool, bundleID: String) {
        if #available(macOS 13.0, *) {
            setLaunchAtLoginUsingSMAppService(enabled, bundleID: bundleID)
        } else {
            setLaunchAtLoginUsingSMLoginItemSetEnabled(enabled, bundleID: bundleID)
        }
    }
    
    
    //MARK: - Private
    
    /// 使用 `SMAppService`（macOS 13+） 设置开机自启动
    ///
    /// - Parameters:
    ///   - enabled: 指定是否启用随系统启动。
    ///   - bundleID: Helper App 的 Bundle Identifier。
    @available(macOS 13.0, *)
    private static func setLaunchAtLoginUsingSMAppService(_ enabled: Bool, bundleID: String) {
        let service = SMAppService.loginItem(identifier: bundleID)
        do {
            if enabled {
                try service.register()
#if DEBUG
                print("✅ 成功注册开机自启动 [\(bundleID)]")
#endif
            } else {
                try service.unregister()
#if DEBUG
                print("✅ 成功取消开机自启动 [\(bundleID)]")
#endif
            }
        } catch {
#if DEBUG
            print("❌ 设置开机自启动失败: \(error.localizedDescription)")
#endif
        }
    }
    
    
    /// 使用 `SMLoginItemSetEnabled`（macOS 12 及以下） 设置开机自启动
    ///
    /// - Parameters:
    ///   - enabled: 指定是否启用随系统启动。
    ///   - bundleID: Helper App 的 Bundle Identifier。
    @available(macOS, introduced: 10.6, deprecated: 13.0, message: "请使用 setLaunchAtLoginUsingSMAppService(_:bundleID:) 代替")
    private static func setLaunchAtLoginUsingSMLoginItemSetEnabled(_ enabled: Bool, bundleID: String) {
        let success = SMLoginItemSetEnabled(bundleID as CFString, enabled)
#if DEBUG
        if success {
            print("✅ Call SMLoginItemSetEnabled with [\(enabled)] success")
        } else {
            print("❌ Call SMLoginItemSetEnabled with [\(enabled)] failed")
        }
#endif
    }
    
}
