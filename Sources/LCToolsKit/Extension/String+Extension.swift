//
//  String+Extension.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Foundation
import Cocoa

/// 为 `String` 扩展路径处理相关功能
public extension String {
    
    /// 生成`指定长度`的`随机字符串`
    /// - Parameter length: 字符串长度
    /// - Returns: 随机字符串
    static func randomString(length: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in chars.randomElement() })
    }
    
    /// 检查字符串是否只包含数字。
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isOnlyDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    
    /// 字符串的最后一个字符（如适用）。
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last else { return nil }
        return String(last)
    }
    
    
    /// 拉丁化字符串（移除变音符号）
    ///
    /// 将带有变音符号的字符转换为基本的拉丁字符。
    ///
    /// - Note: 例如带重音的字母会转换为普通字母，但不改变字母本身
    /// - 示例: "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    
    /// 从字符串中获取整数值（如果适用）
    ///
    /// - Note: 如果字符串可以转换为整数，则返回对应的 Int 值；否则返回 nil
    /// - 示例: "101".int -> 101
    /// - 示例: "42abc".int -> nil
    /// - 示例: "3.14".int -> nil
    ///
    var int: Int? {
        return Int(self)
    }
    
    
    /// 去除字符串`开头`和`结尾`的`空格与换行符`
    ///
    /// 返回一个新的字符串，该字符串移除了原始字符串两端的所有空白字符
    /// 包括空格、制表符、换行符等。
    ///
    /// - 示例: "   hello  \n".trimmed -> "hello"
    /// - 注意: 不会移除字符串中间的空格
    ///
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    /// 按换行符分隔字符串为数组
    ///
    /// 将字符串按照换行符（\n）拆分为多行，返回一个字符串数组。
    /// 空行也会被包含在数组中。
    ///
    /// - 示例: "Hello\ntest".lines() -> ["Hello", "test"]
    /// - 示例: "第一行\n\n第三行".lines() -> ["第一行", "", "第三行"]
    ///
    /// - Returns: 按行分隔的字符串数组
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    
    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// - Note: 此属性不会针对电子邮件服务器验证电子邮件地址。它只是尝试
    /// 确定其格式是否适合作为电子邮件地址
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 计算`当前字符串`在指定`系统字体大小`下的`尺寸`
    ///
    /// - Parameter fontSize: 系统字体大小
    /// - Returns: 计算得到的 CGSize
    ///
    /// - 说明：
    ///   - 如果字符串为空，则自动用空格代替，避免 size 为 0
    ///   - 适用于单行文本尺寸计算
    func calculatedSize(forFontSize fontSize: Int) -> CGSize {
        let font = NSFont.systemFont(ofSize: CGFloat(fontSize))
        let content = self.isEmpty ? " " : self
        return content.size(withAttributes: [.font: font])
    }
    
    
    
    /// 判断字符串是否包含中文字符
    ///
    /// - Returns: `true` 表示包含至少一个中文字符
    var containsChinese: Bool {
        // 使用 Unicode 正则表达式匹配中文字符
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    /// 获取中文字符串的拼音首字母组合（如“微信” → “wx”）
    ///
    /// - Note:
    ///   1. 若字符串不包含中文，返回空字符串
    ///   2. 使用 `CFStringTransform` 将中文转为拼音并去除音调
    ///   3. 提取每个拼音词的首字母组成新字符串
    var pinyinInitials: String {
        guard containsChinese else { return "" }
        let pinyin = transformedPinyin()
        
        // 提取每个拼音词的首字母，并拼接为结果
        return pinyin
            .components(separatedBy: .whitespaces)
            .compactMap { $0.first?.lowercased() }
            .joined()
    }
    
    
    /// 获取中文字符串的完整拼音（无音调、无空格，如“微信” → “weixin”）
    ///
    /// - Note:
    ///   1. 若字符串不包含中文，返回空字符串
    ///   2. 使用 `CFStringTransform` 转为拼音并去除音调
    ///   3. 去除所有空格并转换为小写
    var pinyinFull: String {
        guard containsChinese else { return "" }
        let pinyin = transformedPinyin()
        
        return pinyin
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
    }
    
    
    
    /// 判断`当前路径`是否是`子路径`的`父路径`
    /// - Parameter childPath: 需要判断的子路径
    /// - Returns: 如果当前路径是子路径的父路径，则返回 true，否则返回 false
    func isParentPath(of childPath: String) -> Bool {
        // 去除 当前路径 和 子路径 尾部的 "/"
        let parentPath = self.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let trimmedChildPath = childPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        // 将 当前路径 和 子路径 按 "/" 分割为组件数组
        let parentComponents = parentPath.split(separator: "/")
        let childComponents = trimmedChildPath.split(separator: "/")
        
        // 判断 父路径 组件数是否小于 子路径 组件数，不满足父子关系则返回 false
        guard parentComponents.count < childComponents.count else {
            return false
        }
        
        // 逐层比对父路径和子路径的每一层是否一致
        for (index, parentComponent) in parentComponents.enumerated() {
            if parentComponent != childComponents[index] {
                return false
            }
        }
        
        // 如果父路径的所有层级都匹配子路径的前几层，则返回 true
        return true
    }
    
    
    /// 返回`转义路径后`的`字符串`，将`空格`替换为 `' '`
    func escapedPath() -> String {
        return self.replacingOccurrences(of: " ", with: "' '")
    }
    
    
    
    //MARK: - Private
    
    /// 将中文字符串转换为拼音（去除音调，不含中文判断）
    ///
    /// - Returns: 转换后的拼音字符串（带空格）
    private func transformedPinyin() -> String {
        // 1. 转为可变字符串
        let mutableString = NSMutableString(string: self) as CFMutableString
        
        // 2. 使用 CoreFoundation API 进行拼音转换
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)          // 转拼音
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)  // 去音调
        
        // 3. 转换为 Swift 字符串并返回
        return mutableString as String
    }
    
    
    
}
