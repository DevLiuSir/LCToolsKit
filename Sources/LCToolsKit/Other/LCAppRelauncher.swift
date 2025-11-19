//
//  LCAppRelauncher.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Cocoa



/// App 重启工具类
public class LCAppRelauncher {
    
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
    
    
    
    
}
