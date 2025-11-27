//
//  String+Extension.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Foundation
import Cocoa

/// 为 `String` 扩展路径处理相关功能
public extension String {
    
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
