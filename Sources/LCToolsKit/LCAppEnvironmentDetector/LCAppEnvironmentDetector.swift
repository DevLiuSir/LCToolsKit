//
//  LCAppEnvironmentDetector.swift
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation
import Security


/// App环境检测器（用于判断当前App的运行环境）
public struct LCAppEnvironmentDetector {
    
    /// 单例实例
    public static let shared = LCAppEnvironmentDetector()
    
    private init() {}
    
    
    // 审核中
    public var IsReviewing: Bool {
        return LCAppEnvironmentDetector.currentEnvironment() == .other
    }
    
    // 测试中
    public let IsTesting = LCAppEnvironmentDetector.currentEnvironment() == .testFlight || LCAppEnvironmentDetector.currentEnvironment() == .development
    
    
    /// 获取当前App的运行环境
    public static func currentEnvironment() -> LCAppRunEnvironment {
        // 此方法通过调用 `codesign -dv` 命令读取当前 App 的签名信息，并根据签名中的 Authority 字段判断应用的分发方式。
        let result = runCommand(
            launchPath: "/usr/bin/codesign",
            arguments: ["-dv", "--verbose=4", Bundle.main.bundlePath]
        )
        
        guard result.exitCode == 0 else {
            print("❌ detectEnvironment error: \(result.output)")
            return .other
        }
        
        // 审核中，返回的字符串是 /Applications/xxx.app: No such file or directory
        let lines = result.output.components(separatedBy: "\n")
        let authorityLines = lines.compactMap { $0.hasPrefix("Authority") ? $0 : nil }
        
        for line in authorityLines {
            guard let authority = line.components(separatedBy: "=").last else { continue }
            switch authority {
            case "Apple Mac OS Application Signing":                    return .appStore
            case "TestFlight Beta Distribution":                        return .testFlight
            case let id where id.hasPrefix("Developer ID Application"): return .developerID
            case let id where id.hasPrefix("Apple Distribution"):       return .adHoc
            case let id where id.hasPrefix("Apple Development"):        return .development
            default: break
            }
        }
        return .other
    }
    
    
    /// 执行 shell 命令并获取输出
    ///
    /// - Parameters:
    ///   - launchPath: 可执行文件路径，如 `/usr/bin/codesign`
    ///   - arguments: 命令参数
    /// - Returns: 命令的标准输出（和标准错误合并后）和退出码
    @discardableResult
    private static func runCommand(launchPath: String, arguments: [String]) -> (output: String, exitCode: Int32) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            return (output, process.terminationStatus)
        } catch {
            return ("Command execution failed: \(error)", -1)
        }
    }
    
}
