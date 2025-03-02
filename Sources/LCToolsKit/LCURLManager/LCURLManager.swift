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
    
    
    
}
