//
//  FileManager+Extension.swift
//
//  Created by DevLiuSir on 2023/3/2.
//



import Foundation

/// FileManager 扩展
public extension FileManager {
    
    /// 判断`文件`是否在`垃圾桶`中
    /// - Parameter file: 需要检查的文件URL
    /// - Returns: 如果文件在垃圾桶中，返回true，否则返回false
    func isInTrash(_ file: URL) -> Bool {
        var relationship: URLRelationship = .other // 默认关系为其他
        do {
            // 获取文件与垃圾桶目录之间的关系
            try getRelationship(&relationship, of: .trashDirectory, in: .userDomainMask, toItemAt: file)
            // 如果关系是包含（文件在垃圾桶中），返回true
            return relationship == .contains
        } catch {
            // 如果发生错误，返回false
            return false
        }
    }
    
    /// 检查给定 URL 是否为目录。
    /// - Parameter url: 要检查的 URL。
    /// - Returns: 如果给定 URL 是目录，则返回 true；否则返回 false。
    func isDirectory(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
}
