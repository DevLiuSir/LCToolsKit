//
//
//  LCDeviceInfoManager.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Foundation
import IOKit

/// 设备信息管理器
/// 提供获取设备 UUID、密钥等信息的接口，可扩展其他设备信息
public class LCDeviceInfoManager {
    
    /// 获取设备完整 UUID，如果获取失败则生成一个新的 UUID
    public static func getFullUUID() -> String {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        guard service != 0 else { return UUID().uuidString }
        defer { IOObjectRelease(service) }
        
        guard let str = IORegistryEntryCreateCFProperty(service, "IOPlatformUUID" as CFString, kCFAllocatorDefault, .zero)
            .takeUnretainedValue() as? String else {
            return UUID().uuidString
        }
        return str
    }
    
    
    /// 获取`设备的 UUID` 的`后 12 位作`为`密钥`
    ///
    /// - Returns: 返回 UUID 的后 12 位字符串，如果获取失败则返回空字符串
    public static func getUUIDLast12() -> String {
        /// 存储 UUID 的变量
        var uuid = ""
        
        /// 获取 IOPlatformExpertDevice 服务
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        
        if platformExpert != 0 {
            // 从 IORegistry 中读取 "IOPlatformUUID" 属性
            if let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, "IOPlatformUUID" as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? String {
                // 提取 UUID 的最后 12 位
                let components = serialNumberAsCFString.components(separatedBy: "-")
                if components.count > 4 {
                    uuid = components[4]
                }
            }
            // 释放 IOPlatformExpertDevice 服务
            IOObjectRelease(platformExpert)
        }
        // 返回 UUID 的后 12 位
        return uuid
    }
    
}
