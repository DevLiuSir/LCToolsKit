//
//  L10n.swift
//
//  Created by DevLiuSir on 2023/3/20.
//

import Foundation


/// L10n 是 Localization 的简写
public class L10n {
    /**
     获取本地化字符串并替换格式占位符。
     
     - Parameters:
     - key: 本地化字符串的键。
     - params: 用于替换本地化字符串中格式占位符（如 `%@`, `%d`, `%.2f`）的参数，支持多种类型。
     - comment: 本地化字符串的注释，默认值为空字符串。
     
     - Returns: 替换占位符后的本地化字符串。
     
     - Note: 本方法使用 `String(format:arguments:)` 进行占位符替换，因此请确保 `.strings` 文件中的值使用有效的格式字符串。
     */
    public static func localized(_ key: String, _ params: CVarArg..., comment: String = "") -> String {
        let string = NSLocalizedString(key, comment: comment)
        return String(format: string, arguments: params)
    }
    
}
