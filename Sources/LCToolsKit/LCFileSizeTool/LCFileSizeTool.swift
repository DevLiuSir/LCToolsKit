//
//  LCFileSizeTool.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation

/// 文件管理器
public class LCFileSizeTool {
    
    /// 单例
    public static let shared = LCFileSizeTool()
    
    /// ByteCountFormatter 用于格式化文件大小
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB, .useTB] // 支持的单位
        formatter.zeroPadsFractionDigits = true // 避免文字跳动
        formatter.countStyle = .file        // 文件大小样式，符合 Finder 格式
        return formatter
    }()
    
    
    /// 使用 ByteCountFormatter 格式化大小
    public func formatSize(_ size: UInt64) -> String {
        return byteFormatter.string(fromByteCount: Int64(size))
    }
    
    /// 获取`应用沙盒`的`主目录路径` (`Data` 路径)
    /// - Returns: 应用的沙盒主目录路径
    public static func getSandboxDataPath() -> String {
        guard let homePath = FileManager.default.homeDirectoryForCurrentUser.path as String? else {
            return ""
        }
        return homePath
    }
    
    
    /// 判断`给定路径`是否`存在`
    /// 检查指定路径的文件是否存在
    /// - Parameter path: 文件路径
    /// - Returns: 如果文件存在，返回 true；否则返回 false
    public static func fileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path) // 返回路径是否存在的布尔值
    }
    
    /// 检查`给定 URL` 是否为`目录。`
    /// - Parameter url: 要检查的 URL。
    /// - Returns: 如果给定 URL 是目录，则返回 true；否则返回 false。
    public static func isDirectory(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    //MARK: - 计算大小
    
    /// `计算给定路径`的大小
    /// - Parameter path: 文件或目录的完整路径
    /// - Returns: 路径的大小（以字节为单位）
    public static func calculateSize(at path: String) -> UInt64 {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // 检查路径是否存在以及是否为目录
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
            print("Invalid path: \(path)")
            return 0
        }
        
        if isDirectory.boolValue || path.hasSuffix(".app") {
            // 如果是目录或 `.app`，计算目录大小
            return calculateDirectorySize(at: path)
        } else {
            // 如果是普通文件，计算文件大小
            return calculateFileSize(at: path)
        }
    }
    
    /// `递归计算``指定路径`的`目录大小`
    /// - Parameter path: 目录的完整路径
    /// - Returns: 目录的总大小（以字节为单位）
    public static func calculateDirectorySize(at path: String) -> UInt64 {
        let fileManager = FileManager.default
        var totalSize: UInt64 = 0

        // 使用 enumerator 遍历目录内容，逐步获取路径，避免一次性加载到内存中
        guard let enumerator = fileManager.enumerator(
            at: URL(fileURLWithPath: path),
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey], // 同时获取文件大小和是否为目录的属性
            options: [.skipsHiddenFiles] // 跳过隐藏文件，减少不必要的计算
        ) else {
            print("无法获取目录枚举器: \(path)")
            return totalSize
        }
        
        // 遍历目录中的每个文件和子目录
        for case let fileURL as URL in enumerator {
            do {
                // 获取当前路径的资源属性，包括是否为目录和文件大小
                let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey])
                
                // 如果资源为文件，则累加其大小
                if let isDirectory = resourceValues.isDirectory, !isDirectory, // 判断是否为文件
                   let fileSize = resourceValues.fileSize { // 获取文件大小
                    totalSize += UInt64(fileSize) // 累加文件大小
                }
            } catch {
                // 捕获错误并打印当前路径的错误信息
                print("无法获取文件属性: \(fileURL.path), 错误: \(error)")
            }
        }
        return totalSize
    }
    
    
    /// `计算指定文件`的`大小`
    /// - Parameter path: 文件的完整路径
    /// - Returns: 文件的大小（以字节为单位）
    public static func calculateFileSize(at path: String) -> UInt64 {
        let fileManager = FileManager.default
        
        // 确保文件存在
        guard fileManager.fileExists(atPath: path) else {
            print("File does not exist at path: \(path)")
            return 0
        }
        // 获取文件属性
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            if let fileSize = attributes[.size] as? UInt64 {
                return fileSize
            }
        } catch {
            print("Failed to retrieve file attributes for path: \(path), error: \(error)")
        }
        return 0
    }
    
    
}
