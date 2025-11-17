//
//  LCAppSecurity.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation
import Security


/// 用于获取当前 App 的签名信息，并判断是否已签名
public class LCAppSecurity {
    
    /// 获取当前 App 的签名信息
    /// - Returns: 包含签名信息的字典，如果获取失败返回 nil
    public static func getAppSigningInfo() -> [String: Any]? {
        // 获取 App 的 bundle 路径
        guard let path = Bundle.main.bundlePath as CFString? else { return nil }
        
        // 创建静态代码对象
        var staticCode: SecStaticCode?
        let status = SecStaticCodeCreateWithPath(URL(fileURLWithPath: path as String) as CFURL, [], &staticCode)
        guard status == errSecSuccess, let code = staticCode else { return nil }
        
        // 获取签名信息
        var signingInfo: CFDictionary?
        let infoStatus = SecCodeCopySigningInformation(code,
                                                       SecCSFlags(rawValue: kSecCSSigningInformation),
                                                       &signingInfo)
        guard infoStatus == errSecSuccess else { return nil }
        return signingInfo as? [String: Any]
    }
    
    
    /// 判断当前 App 是否已被签名
    /// - Returns: 如果 App 有签名返回 true，否则 false
    public static func isAppSignedByAppleOrDeveloper() -> Bool {
        guard let info = getAppSigningInfo() else { return false }
        if let signingID = info[kSecCodeInfoIdentifier as String] as? String {
#if DEBUG
            print("签名标识符: \(signingID)")
#endif
        }
        return info[kSecCodeInfoIdentifier as String] != nil
    }
    
    
    /// 检测 App 是否正在被调试（Debugger Attached）
    /// - Returns: 如果 App 正在被调试返回 true，否则 false
    public static func isBeingDebugged() -> Bool {
        // sysctl 调用所需参数
        var name = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info = kinfo_proc()
        var infoSize = MemoryLayout<kinfo_proc>.size
        
        let result = sysctl(&name, UInt32(name.count), &info, &infoSize, nil, 0)
        if result != 0 {
            return false
        }
        
        // P_TRACED 标志表示进程正在被调试
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    
    /// 获取当前应用程序可执行文件的所有者 UID（用户标识符）
    ///
    /// - Returns: 若成功，则返回可执行文件的所有者 UID（`uid_t` 类型转换为 `Int`）；若失败则返回 -1。
    public static func getExecutableOwnerUID_stat() -> Int {
        // 获取当前应用程序的可执行文件路径
        guard let executablePath = Bundle.main.executablePath else {
            return -1
        }
        
        // 用于存储文件状态信息的结构体（来自 C 的 stat 结构）
        var fileStatus = stat()
        
        // 调用 POSIX 的 stat() 函数，获取文件元数据
        if stat(executablePath, &fileStatus) == 0 {
            // 成功获取，返回文件的所有者用户 ID
            return Int(fileStatus.st_uid)
        }
        
        // 如果 stat 失败，则返回 -1
        return -1
    }
    
    
    /// 获取当前应用可执行文件的所有者 UID（使用 FileManager.attributesOfItem）
    ///
    /// - 返回：若成功则返回文件所有者 UID，否则返回 -1。
    public static func getExecutableOwnerUID_fileManager() -> Int {
        // 获取应用的可执行文件路径
        guard let executablePath = Bundle.main.executablePath else { return -1 }
        do {
            // 获取指定文件路径的属性
            let attributes = try FileManager.default.attributesOfItem(atPath: executablePath)
            // 从文件属性中获取所有者账户 ID
            if let accountID = attributes[.ownerAccountID] as? NSNumber {
                return accountID.intValue
            }
        } catch {
            print("⚠️ 获取可执行文件 UID 失败：\(error.localizedDescription)")
        }
        return -1
    }
    
    
    
    
    
}
