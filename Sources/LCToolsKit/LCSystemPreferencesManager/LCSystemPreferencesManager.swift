//
//  LCSystemPreferencesManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation
import AppKit


/// 用于管理系统偏好设置跳转的工具类
public class LCSystemPreferencesManager {
    
    /// 打开“登录项”设置面板
    public static func openLoginItemsPreferences() {
        // 使用 #available 判断 macOS 系统版本
        if #available(macOS 14.0, *) {
            // macOS Sonoma 及以上
            if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension?ExtensionItems") {
                NSWorkspace.shared.open(url)
            } else {
                print("无法构建 URL 以打开登录项设置")
            }
        } else {
            // macOS 13 Ventura 及以下
            if let url = URL(string: "x-apple.systempreferences:com.apple.preferences.users?startupItemsPref") {
                NSWorkspace.shared.open(url)
            } else {
                print("无法构建 URL 以打开用户与组启动项设置")
            }
        }
    }
    
    /// 打开系统偏好设置 -> 辅助功能
    public static func openAccessibilityPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
    
    /// 打开系统偏好设置 -> 录屏与系统录音
    public static func openScreenCapturePreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        NSWorkspace.shared.open(url)
    }
    
    /// 打开系统偏好设置 -> 提醒事项
    public static func openReminderPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders") {
            if NSWorkspace.shared.open(url) {
                print("成功打开系统偏好设置")
            } else {
                print("无法打开系统偏好设置")
            }
        }
    }
    
    /// 媒体与 Apple Music 权限
    public static func openMediaLibraryPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_MediaLibrary")!
        NSWorkspace.shared.open(url)
    }
    
    /// 照片权限
    public static func openPhotosPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Photos")!
        NSWorkspace.shared.open(url)
    }
    
    
    /// 通讯录权限
    public static func openContactsPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts")!
        NSWorkspace.shared.open(url)
    }
    
    /// 麦克风权限
    public static func openMicrophonePreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")!
        NSWorkspace.shared.open(url)
    }
    
    /// 摄像头权限
    public static func openCameraPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!
        NSWorkspace.shared.open(url)
    }
    
    /// 输入监控权限
    public static func openListenEventPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!
        NSWorkspace.shared.open(url)
    }
    
    /// 语音识别权限
    public static func openSpeechRecognitionPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition")!
        NSWorkspace.shared.open(url)
    }
    
    /// 定位服务（位置与隐私）
    public static func openLocationServicesPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!
        NSWorkspace.shared.open(url)
    }
    
    /// 全盘访问权限（Full Disk Access）
    public static func openFullDiskAccessPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
        NSWorkspace.shared.open(url)
    }
    
    /// 文件与文件夹权限（Files and Folders）
    public static func openFilesAndFoldersPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_FilesAndFolders")!
        NSWorkspace.shared.open(url)
    }
    
    /// 蓝牙权限
    public static func openBluetoothPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Bluetooth")!
        NSWorkspace.shared.open(url)
    }
    
    /// 日历权限
    public static func openCalendarPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars")!
        NSWorkspace.shared.open(url)
    }
    
    /// 自动化权限
    public static func openAutomationPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!
        NSWorkspace.shared.open(url)
    }
    
    /// 打开系统偏好设置 -> 指定的模块
    /// - Parameter urlString: 偏好设置的 URL Scheme
    public static func openPreferences(with urlString: String) {
        if let url = URL(string: urlString) {
            if NSWorkspace.shared.open(url) {
                print("成功打开系统偏好设置")
            } else {
                print("无法打开系统偏好设置")
            }
        } else {
            print("无效的 URL: \(urlString)")
        }
    }
    
}
