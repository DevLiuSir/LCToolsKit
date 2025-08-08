//
//  LCTextHighlighter.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation
import Cocoa



/// 文字高亮工具
public class LCTextHighlighter {
    
    //MARK: - Public
    
    /// 高亮显示文本中的关键词（支持单个、多个关键字）
    ///
    /// - Parameters:
    ///   - keywords: 要高亮显示的关键词数组
    ///   - text: 原始文本
    ///   - attributes: 高亮的文本属性
    ///   - underline: 是否添加下划线（默认 true）
    /// - Returns: 返回带有多个关键词高亮效果的富文本
    public static func highlight(keywords: [String], in text: String, attributes: [NSAttributedString.Key: Any],
                                 underline: Bool = true) -> NSAttributedString {
        
        /// 创建一个可变的富文本字符串，作为最终返回结果
        let attributedString = NSMutableAttributedString(string: text)
        
        /// 将 Swift 字符串转换为 NSString，以便使用 NSRange 进行位置查找
        let nsText = text as NSString
        
        /// 遍历每一个关键词，分别进行高亮处理
        for keyword in keywords {
            // 针对每个关键词单独操作
            applyHighlight(for: keyword, in: attributedString, originalText: nsText, attributes: attributes, underline: underline)
        }
        // 返回已处理好的富文本
        return attributedString
    }
    
    
    
    /// 将 NSAttributedString 转换为纯文本
    ///
    /// - Parameter attributedString: 富文本对象
    /// - Returns: 提取出的纯文本字符串
    public static func convertToPlainText(from attributedString: NSAttributedString) -> String {
        return attributedString.string
    }
    
    
    
    //MARK: - Private
    
    /// 通用的关键词高亮逻辑，用于在富文本中查找并应用属性样式
    ///
    /// - Parameters:
    ///   - keyword: 需要高亮的关键词
    ///   - attributedString: 要在其上应用高亮的可变富文本对象
    ///   - originalText: 原始文本（NSString 格式），用于 NSRange 搜索
    ///   - attributes: 要应用的富文本属性（如字体、前景色、背景色等）
    ///   - underline: 是否为关键词添加下划线（true 表示添加）
    private static func applyHighlight(for keyword: String, in attributedString: NSMutableAttributedString,
                                       originalText: NSString,
                                       attributes: [NSAttributedString.Key: Any],
                                       underline: Bool) {
        // 初始化搜索范围，从文本的起始位置开始
        var searchRange = NSRange(location: 0, length: originalText.length)
        
        /// 循环`搜索关键词`在文本中的`位置`，直到`搜索完整个文本`
        while searchRange.location < originalText.length {
            
            /// 查找`关键词`在当前`搜索范围内`的位置，`caseInsensitive`：忽略大小写
            let foundRange = originalText.range(of: keyword, options: .caseInsensitive, range: searchRange)
            
            /// 检查`是否找到`关键词
            if foundRange.location != NSNotFound {
                // 添加富文本属性，使`关键词`高亮显示
                attributedString.addAttributes(attributes, range: foundRange)
                
                if underline {
                    // 添加`下划线`效果
                    attributedString.addAttribute(.underlineStyle,
                                                  value: NSUnderlineStyle.single.rawValue,
                                                  range: foundRange)
                }
                /// 更新`搜索范围`，`继续查找`后续`匹配项`
                let nextLocation = foundRange.location + foundRange.length
                searchRange = NSRange(location: nextLocation, length: originalText.length - nextLocation)
            } else {
                // 如果没有找到更多匹配项，跳出循环
                break
            }
        }
    }
    
    
}
