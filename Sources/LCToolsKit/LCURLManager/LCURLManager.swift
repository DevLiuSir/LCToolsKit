//
//  LCURLManager.swift
//
//  Created by DevLiuSir on 2023/3/2.
//

import Foundation
import AppKit

/// URL管理器
public class LCURLManager {
    
    /// 打开指定的 URL
    /// - Parameter urlString: 目标 URL 的字符串
    public static func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("无效的 URL: \(urlString)")
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    
    /// 打开`搜索 URL`, 并传递`关键字`作为`参数`
    ///
    /// - Parameters:
    ///   - baseURL: 搜索引擎基础 URL
    ///   - keyword: 搜索关键词
    public static func openSearchURL(baseURL: String, keyword: String) {
        // 对关键字进行URL编码，以便在URL中使用
        if let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // 构建搜索URL
            let urlString = baseURL + encodedKeyword
            if let url = URL(string: urlString) {
                // 使用NSWorkspace打开URL
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    
    
}
