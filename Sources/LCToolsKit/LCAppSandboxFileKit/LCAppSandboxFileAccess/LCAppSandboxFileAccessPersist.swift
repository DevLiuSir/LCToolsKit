//
//  LCAppSandboxFileAccessPersist.swift
//  IPSWLibrary
//
//  Created by Liu Chuan on 2019/12/20.
//



import Foundation


/// 应用程序`沙箱文件访问持久`
class LCAppSandboxFileAccessPersist: NSObject, LCAppSandboxFileAccessProtocol {

    /// 生成给定URL的书签数据的键
    ///
    /// - Parameter url: 要生成键的URL
    /// - Returns: 生成的键
    class func keyForBookmarkData(for url: URL) -> String {
        let urlStr = url.absoluteString
        return "bd_\(urlStr)"
    }

    /// 获取给定URL的书签数据
    ///
    /// - Parameter url: 要获取书签数据的URL
    /// - Returns: 书签数据，如果获取失败则为nil
    func bookmarkData(for url: URL) -> Data? {
        let defaults = UserDefaults.standard

        var subURL = url
        while true {
            // 当路径中只剩下'/'时退出循环
            if subURL.path == "/" {
                break
            }

            // 获取与URL对应的书签数据的键
            let key = LCAppSandboxFileAccessPersist.keyForBookmarkData(for: subURL)

            // 尝试从UserDefaults中获取书签数据
            if let bookmark = defaults.data(forKey: key) {
                return bookmark
            }

            // 删除最后一个路径组件，继续向上查找
            subURL = subURL.deletingLastPathComponent()
        }

        // 未找到URL或其父级的书签
        return nil
    }

    /// 为指定的URL设置书签数据
    ///
    /// - Parameters:
    ///   - data: 要设置的书签数据
    ///   - url: 要设置书签数据的URL
    func setBookmarkData(_ data: Data, for url: URL) {
        let defaults = UserDefaults.standard
        let key = LCAppSandboxFileAccessPersist.keyForBookmarkData(for: url)
        defaults.set(data, forKey: key)
    }

    /// 清除指定URL的书签数据
    ///
    /// - Parameter url: 要清除书签数据的URL
    func clearBookmarkData(for url: URL) {
        let defaults = UserDefaults.standard
        let key = LCAppSandboxFileAccessPersist.keyForBookmarkData(for: url)
        defaults.removeObject(forKey: key)
    }
    
    
}
