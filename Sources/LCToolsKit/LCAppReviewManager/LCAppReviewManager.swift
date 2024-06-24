//
//  LCAppReviewManager.swift
//  LCAppReviewManager
//
//  Created by DevLiuSir on 2021/6/24.
//

import Foundation


/// 应用审核管理器，负责处理应用的审核状态和反盗版检查。
public class LCAppReviewManager {
    
    /// 反盗版，判断`审核`是否`通过`
    /// - Returns: 审核是否通过
    public class func antiPiracy() -> Bool {
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
    public class func isAppleReview() -> Bool {
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
    
}
