//
//  L10n.swift
//
//  Created by DevLiuSir on 2023/3/20.
//

import Foundation


/// L10n 是 Localization 的简写
public class L10n {
    /**
     获取本地化字符串并替换参数。
     - Parameters:
     - key: 本地化字符串的键。
     - params: 替换本地化字符串中占位符的参数。
     - comment: 本地化字符串的注释，默认为空字符串。
     - Returns: 已替换参数的本地化字符串。
     */
    public static func localized(_ key: String, _ params: String..., comment: String = "") -> String {
        // 获取本地化字符串
        var string = NSLocalizedString(key, comment: comment)
        // 替换占位符
        if !params.isEmpty {
            string = String(format: string, arguments: params)
        }
        return string
    }
    
}
