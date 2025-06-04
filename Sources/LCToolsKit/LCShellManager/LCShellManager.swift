//
//  LCShellManager.swift
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation

/**
 `@discardableResult` 是 Swift 中的一个属性修饰符，用于函数或方法的定义。
 
 默认情况下，如果调用一个带有返回值的方法却没有使用这个返回值，编译器会发出警告。
 使用 `@discardableResult` 后，即使调用者忽略函数的返回值，编译器也不会产生警告。
 
 主要用途：
 - 允许调用者忽略函数的返回值（例如仅关注副作用）
 - 常用于工具函数、链式调用或执行结果可选的情境
 
 */

/// Shell 命令管理器
public class LCShellManager {
    
    /// 根据 macOS 版本选择默认 shell 路径
    private static var shellPath: String {
        if #available(macOS 10.15, *) {
            return "/bin/zsh" // macOS Catalina 及以上使用 zsh
        } else {
            return "/bin/bash" // 更早版本使用 bash
        }
    }
    
    /// 执行命令并忽略输出。
    /// - Parameter command: 要执行的 shell 命令。
    public static func run(_ command: String) {
        let process = Process()             // 创建一个进程对象，用于执行命令
        process.launchPath = shellPath      // 设置进程的启动路径（指定 shell 程序）
        process.arguments = ["-c", command] // 将命令作为参数传递给 shell
        process.launch()            // 启动进程
        process.waitUntilExit()     // 等待进程结束
    }
    
    /// 执行命令并返回标准输出（包含标准错误输出）。
    /// - Parameter command: 要执行的 shell 命令。
    /// - Returns: 命令执行结果的输出文本。
    @discardableResult
    public static func runWithOutput(_ command: String) -> String {
        let process = Process()
        process.launchPath = shellPath
        process.arguments = ["-c", command]
        // 创建管道，以便从子进程中读取输出
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        // 启动子进程，等待子进程结束，并等待输出管道有数据
        process.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        // 返回输出结果
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// 强制终止指定的进程。
    /// - Parameter pid: 要终止的进程 ID。
    public static func forceTerminateProcess(pid: Int32) {
        // 设置可执行文件路径，这里是系统的 `kill` 命令
        // 设置命令的参数，`-9` 表示强制终止进程，后跟要终止的进程 ID
        let process = Process()
        process.launchPath = "/bin/kill"
        process.arguments = ["-9", "\(pid)"]
        
        do {
            try process.run()           // 尝试运行该进程
            process.waitUntilExit()     // 等待子进程执行完成
            // 获取子进程的退出状态码
            let status = process.terminationStatus
            if status == 0 {            // 根据状态码判断是否成功
                print("Process \(pid) terminated successfully.")
            } else {
                print("Failed to terminate process \(pid). Status code: \(status)")
            }
        } catch {
            print("Error terminating process \(pid): \(error.localizedDescription)")
        }
    }
}
