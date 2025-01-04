//
//  LCCFNotificationManager.swift
//
//  Created by DevLiuSir on 2022/8/11.
//
//


import Foundation


/*
 该类提供了两种类型的通知功能：Darwin 通知 和 Distributed 通知。
 
 - Darwin 通知：
   - 用于在同一设备上的应用程序之间进行通信。
   - 常见于 macOS 应用之间的进程间通信。
   - 适合本地系统范围内的通知，无需网络支持。
 
 - Distributed 通知：
   - 用于跨设备或系统的进程间通信。
   - 通常用于多台设备或系统之间的信息同步或广播。
   - 适合需要分布式环境下的通知，如多用户会话或网络间通信。

 ### 选项优点
 - .deliverImmediately：   - 确保通知被立即送达，而不会被队列或延迟。
 - .postToAllSessions：
   - 将通知广播到所有用户会话，而不仅仅限于当前用户会话。
   - 特别适用于多用户环境或分布式系统的通知场景。
*/



public class LCCFNotificationManager {
    
    
    //MARK: 沙盒内发送的CF通知，无法传递userinfo字典，只能发送通知名称
    
    /// 发送 `Darwin` 通知,
    /// - Parameter name: 通知的名称，用于标识要发送的通知
    public static func postDarwinNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = CFNotificationName(name as CFString)
        // 设置选项，包含 立即发送 和 广播到 所有会话
        let options: CFOptionFlags = kCFNotificationDeliverImmediately | kCFNotificationPostToAllSessions
        // 发送通知
        CFNotificationCenterPostNotificationWithOptions(notificationCenter, notificationName, nil, nil, options)
    }
    
    /// 注册 `Darwin` 通知的监听
    /// - Parameters:
    ///   - name: 通知的名称，用于指定要监听的通知
    ///   - callback: 回调函数，当通知被触发时调用
    public static func registerDarwinNotification(named name: String, callback: @escaping CFNotificationCallback) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = name as CFString
        CFNotificationCenterAddObserver(notificationCenter, nil, callback, notificationName, nil, .deliverImmediately)
    }
    
    
    
    //MARK: 非沙盒内发送的CF通知 Distributed，可以传递userinfo字典
    
    /// 发送 `Distributed` 通知，并附带字典信息
    /// - Parameters:
    ///   - name: 通知的名称，用于标识要发送的通知
    ///   - userInfo: 附加的字典信息，作为通知的附加数据
    public static func postDistributedNotification(named name: String, userInfo: CFDictionary? = nil) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = CFNotificationName(name as CFString)
        
        // 设置选项，包含 立即发送 和 广播到 所有会话
        let options: CFOptionFlags = kCFNotificationDeliverImmediately | kCFNotificationPostToAllSessions
        
        // 发送通知
        CFNotificationCenterPostNotificationWithOptions(notificationCenter, notificationName, nil, userInfo, options)
    }
    
    
    /// 注册 `Distributed` 通知的监听
    /// - Parameters:
    ///   - name: 通知的名称，用于指定要监听的通知
    ///   - callback: 回调函数，当通知被触发时调用
    public static func registerDistributedNotification(named name: String, callback: @escaping CFNotificationCallback) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = name as CFString
        CFNotificationCenterAddObserver(notificationCenter, nil, callback, notificationName, nil, .deliverImmediately)
    }
    
    /// 移除` Darwin` 通知的监听
    /// - Parameter name: 通知的名称，用于指定要移除的监听
    public static func removeDarwinNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterRemoveObserver(notificationCenter, nil, notificationName, nil)
    }
    
    /// 移除 `Distributed` 通知的监听
    /// - Parameter name: 通知的名称，用于指定要移除的监听
    public static func removeDistributedNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterRemoveObserver(notificationCenter, nil, notificationName, nil)
    }
}
