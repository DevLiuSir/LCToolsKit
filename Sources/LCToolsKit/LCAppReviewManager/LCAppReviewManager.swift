//
//  LCAppReviewManager.swift
//
//  Created by DevLiuSir on 2021/6/24.
//

import Foundation

/// 应用审核管理器，负责处理应用的审核状态和反盗版检查。
public class LCAppReviewManager {
    
    /// 单例模式
    static let shared = LCAppReviewManager()
    
    /// 审核开始时间
    private var beginDate: Date?
    
    /// 审核结束时间
    private var endDate: Date?
    
    /// 私有构造函数，防止外部初始化
    private init() {}
    
    
    /// 反盗版，判断`审核`是否`通过`
    /// - Returns: 审核是否通过
    public static func antiPiracy() -> Bool {
        // 获取应用的可执行文件路径
        guard let filePath = Bundle.main.executablePath else { return false }
        
        do {
            // 获取指定文件路径的属性
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
            // 从文件属性中获取所有者账户 ID
            guard let accountID = attributes[.ownerAccountID] as? NSNumber else { return false }
            
            if accountID.intValue == 501 {          // // 如果所有者账户 ID 为 501： 审核中
                print("501")
                return false
                // 如果所有者账户 ID 为 0
            } else if accountID.intValue == 0 {     // 如果所有者账户 ID 为 0：   审核通过
                // 返回 true
                return true
            }
        } catch {
            // 如果出现错误，打印错误信息
            print("Error: \(error)")
        }
        
        // 如果所有者账户 ID 既不是 501，也不是 0，返回 false
        return false
    }
    
    
    
    /// 检查`应用`是否在  `Apple 审核中`
    /// - Returns: 如果应用处于审核中，则返回 true；否则返回 false
    public static func isAppleReview() -> Bool {
        // 获取应用的 App Store 购买凭证路径 《票据》
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              // 检查凭证文件是否存在, 如果凭证文件不存在，表示不是来自 App Store 下载的应用
              FileManager.default.fileExists(atPath: receiptURL.path) else {
            return false
        }
        
        // 如果凭证文件存在，表示是来自 App Store 下载的应用
        if let execPath = Bundle.main.executablePath,
           // 获取可执行文件的属性信息
           let attrInfo = try? FileManager.default.attributesOfItem(atPath: execPath),
           // 获取所有者账户 ID
           let ownerAccountID = attrInfo[.ownerAccountID] as? NSNumber,
           // 检查所有者账户 ID 是否为 501，即是否处于审核中
           ownerAccountID.intValue == 501 {     // 如果所有者账户 ID 为 501，表示应用处于审核中
            return true
        } else {    // 如果所有者账户 ID 不为 501，表示应用已发布到 App Store
            return false
        }
    }
    
    /// 设置`审核屏蔽`的`时间段`
    /// - Parameters:
    ///   - beginDate: 开始时间（北京时间），格式：yyyy-MM-dd HH:mm:ss
    ///   - endDate: 结束时间（北京时间），格式：yyyy-MM-dd HH:mm:ss
    public static func setAppleReview(beginDate: String?, endDate: String?) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        // 设置审核的 开始时间
        if let begin = beginDate {
            shared.beginDate = formatter.date(from: begin)
        }
        
        // 设置审核的 结束时间
        if let end = endDate {
            shared.endDate = formatter.date(from: end)
        }
    }
    
    /// 设置`审核屏蔽`的`结束时间`
    /// - Parameter endDate: 结束时间（北京时间），格式：yyyy-MM-dd HH:mm:ss
    public static func setAppleReviewEndDate(_ endDate: String) {
        setAppleReview(beginDate: nil, endDate: endDate)
    }
    
    /// 判断`是否处于审核中`（基于时间戳）
    /// - Returns: 返回当前时间是否在审核时间段内
    public static func isAppleReviewWithTimestamps() -> Bool {
        guard let beginDate = shared.beginDate, let endDate = shared.endDate else {
            return false
        }
        
        // 获取当前时间
        let now = Date()
        
        // 判断当前时间是否在审核时间段内
        return beginDate <= now && now <= endDate
    }
    
}
