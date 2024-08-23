//
//  LCCFNotificationManager.swift
//
//  Created by DevLiuSir on 2022/8/11.
//
//


import Foundation


/*
 这个类提供了发送和注册两种类型的通知功能：Darwin 通知和 Distributed 通知。
 - **Darwin 通知**：用于在同一台设备上的应用程序之间进行通信。通常在 Mac 应用程序之间使用，适合本地系统范围的通知。
 - **Distributed 通知**：用于跨不同设备或系统的进程间通信，适合需要跨网络或不同设备间传递的通知。通常用于在多台设备或系统间进行同步或广播信息。
 */


public class LCCFNotificationManager {
    
    /// 发送 Darwin 通知
    /// - Parameter name: 通知的名称，用于标识要发送的通知
    public static func postDarwinNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
    }
    
    /// 注册 Darwin 通知的监听
    /// - Parameters:
    ///   - name: 通知的名称，用于指定要监听的通知
    ///   - callback: 回调函数，当通知被触发时调用
    public static func registerDarwinNotification(named name: String, callback: @escaping CFNotificationCallback) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = name as CFString
        CFNotificationCenterAddObserver(notificationCenter, nil, callback, notificationName, nil, .deliverImmediately)
    }
    
    /// 发送 Distributed 通知，并附带字典信息
    /// - Parameters:
    ///   - name: 通知的名称，用于标识要发送的通知
    ///   - userInfo: 附加的字典信息，作为通知的附加数据
    public static func postDistributedNotification(named name: String, userInfo: CFDictionary? = nil) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, userInfo, true)
    }
    
    /// 注册 Distributed 通知的监听
    /// - Parameters:
    ///   - name: 通知的名称，用于指定要监听的通知
    ///   - callback: 回调函数，当通知被触发时调用
    public static func registerDistributedNotification(named name: String, callback: @escaping CFNotificationCallback) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = name as CFString
        CFNotificationCenterAddObserver(notificationCenter, nil, callback, notificationName, nil, .deliverImmediately)
    }
    
    /// 移除 Darwin 通知的监听
    /// - Parameter name: 通知的名称，用于指定要移除的监听
    public static func removeDarwinNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterRemoveObserver(notificationCenter, nil, notificationName, nil)
    }
    
    /// 移除 Distributed 通知的监听
    /// - Parameter name: 通知的名称，用于指定要移除的监听
    public static func removeDistributedNotification(named name: String) {
        let notificationCenter = CFNotificationCenterGetDistributedCenter()
        let notificationName = CFNotificationName(name as CFString)
        CFNotificationCenterRemoveObserver(notificationCenter, nil, notificationName, nil)
    }
}
