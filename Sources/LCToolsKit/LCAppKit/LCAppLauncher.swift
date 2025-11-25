//
//
//  LCAppLauncher.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Cocoa

/// App 启动工具类
public class LCAppLauncher {
    
    
    // MARK: - 启动
    
    /// 启动`指定 Bundle Identifier` 的应用程序
    ///
    /// - Parameters:
    ///   - bundleIdentifier: 应用程序的 Bundle Identifier
    public static func launchApp(with bundleIdentifier: String) {
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
            print("未找到 Bundle Identifier 为 \(bundleIdentifier) 的应用程序")
            return
        }
        launchAppCore(at: appURL)
    }
    
    /// 启动`指定路径`的应用程序
    ///
    /// - Parameters:
    ///   - appURL: 应用程序的文件 URL
    public static func launchApp(at appURL: URL) {
        launchAppCore(at: appURL)
    }
    
    
    
    //MARK: - 重启
    
    
    /// 安全重启 App，会调用 AppDelegate 的退出流程
    public static func restartAppSafely() {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", Bundle.main.bundlePath]
        task.launch()
        
        // 安全退出应用，触发 applicationWillTerminate 等生命周期方法
        NSApp.terminate(nil)
    }
    
    /// 强制重启 App，立即退出进程，不触发生命周期方法
    public static func relaunchAppForcefully() {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", Bundle.main.bundlePath]
        task.launch()
        
        // 立即杀死进程
        exit(0)
    }
    
    
    //MARK: - Private
    
    /// 启动`指定路径`的应用程序
    ///
    /// - Parameters:
    ///   - appURL: 应用程序的文件 URL
    private static func launchAppCore(at appURL: URL) {
        if #available(macOS 10.15, *) {
            let configuration = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: appURL, configuration: configuration) { app, error in
                if let app = app {
#if DEBUG
                    print("应用程序 \(appURL.path) 启动成功，\(app.bundleIdentifier ?? "未知")")
#endif
                } else if let error = error {
#if DEBUG
                    print("启动应用程序失败：\(error.localizedDescription)")
#endif
                }
            }
        } else {
            // macOS 10.14 及以下
            do {
                try NSWorkspace.shared.launchApplication(at: appURL, options: [], configuration: [:])
#if DEBUG
                print("应用程序 \(appURL.path) 启动成功")
#endif
            } catch {
#if DEBUG
                print("启动应用程序失败：\(error.localizedDescription)")
#endif
            }
        }
    }
    
}
