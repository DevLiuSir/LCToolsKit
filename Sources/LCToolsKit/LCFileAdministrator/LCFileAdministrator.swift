//
//  LCFileAdministrator.swift
//  LCFileAdministrator
//
//  Created by DevLiuSir on 2021/6/24.
//

import Foundation
import CryptoKit


// LCFileAdministrator 类在 macOS 10.15 及更高版本上可用

@available(macOS 10.15, *)
/// 文件管理器
public class LCFileAdministrator {
    
    /// 比较`两个文件`的` SHA256 哈希值`和`修改时间`，判断它们`是否相同`
    /// - Parameters:
    ///   - sourcePath: 第一个文件的路径
    ///   - destinationPath: 第二个文件的路径
    /// - Returns: 一个布尔值，表示两个文件的内容和时间戳是否相同
    public class func checkFileAreEqual(sourcePath: String, destinationPath: String) -> Bool {
        // 计算第一个文件的 SHA256 哈希值
        guard let sourceHash = sha256Hash(forFileAtPath: sourcePath),
              // 计算第二个文件的 SHA256 哈希值，并比较两者是否相同
              let destinationHash = sha256Hash(forFileAtPath: destinationPath),
              sourceHash == destinationHash else {
            return false
        }
        
        // 获取第一个文件的修改时间
        guard let sourceDate = modificationDate(forFileAtPath: sourcePath),
              // 获取第二个文件的修改时间，并比较两者是否相同
              let destinationDate = modificationDate(forFileAtPath: destinationPath),
              sourceDate == destinationDate else {
            return false
        }
        
        // 如果两个文件的 SHA256 哈希值和修改时间都相同，则返回 true，表示两个文件相同
        return true
    }
    
    /// 计算`指定文件`的 `SHA256 哈希值`
    /// - Parameter path: 文件的路径
    /// - Returns: 文件的 SHA256 哈希值的字符串表示
    static private func sha256Hash(forFileAtPath path: String) -> String? {
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        
        let hash = SHA256.hash(data: fileData)
        
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// 获取`指定文件`的`修改时间`
    /// - Parameter path: 文件的路径
    /// - Returns: 文件的修改时间
    static private func modificationDate(forFileAtPath path: String) -> Date? {
        guard let attributes = fileAttributes(atPath: path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return nil
        }
        return modificationDate
    }
    
    /// 获取`指定文件`的`属性`
    /// - Parameter path: 文件的路径
    /// - Returns: 文件的属性
    static private func fileAttributes(atPath path: String) -> [FileAttributeKey: Any]? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            return attributes
        } catch {
            print("Error getting attributes for file at path \(path): \(error)")
            return nil
        }
    }
    
}
