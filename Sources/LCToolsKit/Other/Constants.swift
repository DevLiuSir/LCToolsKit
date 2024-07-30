//
//  Constants.swift
//  LCShortcutDemo
//
//  Created by Liu Chuan on 2024/7/30.
//


import Cocoa
import Foundation


/*-------------------- 数据类型转换 -----------------*/

// Int 转换为字符串
func stringFromInt(_ int: Int) -> String {
    return "\(int)"
}

// UInt 转换为字符串
func stringFromUInt(_ uint: UInt) -> String {
    return "\(uint)"
}

// Int 转换为字符串
func stringFromInteger(_ integer: Int) -> String {
    return "\(integer)"
}

// UInt 转换为字符串
func stringFromUInteger(_ uinteger: UInt) -> String {
    return "\(uinteger)"
}

// Float 转换为字符串
func stringFromFloat(_ float: Float) -> String {
    return "\(float)"
}

// Float 转换为价格格式的字符串，保留两位小数
func stringFromFloatPrice(_ float: Float) -> String {
    return String(format: "%.2f", float)
}




/*-------------------- 屏幕 -----------------*/

// 屏幕的缩放因子
let kScreenScale: CGFloat = {
    return NSScreen.main?.backingScaleFactor ?? 1.0
}()

// 屏幕的宽度
let kScreenWidth: CGFloat = {
    return NSScreen.main?.frame.size.width ?? 0.0
}()

// 屏幕的高度
let kScreenHeight: CGFloat = {
    return NSScreen.main?.frame.size.height ?? 0.0
}()

// 状态栏的高度
let kStatusBarHeight: CGFloat = {
    return NSApp.mainMenu?.menuBarHeight ?? 0.0
}()


/*-------------------- 字体 -----------------*/

/// 返回`指定大小`的`系统字体`
/// - Parameter size: 字体大小
/// - Returns: 系统字体
func font(ofSize size: CGFloat) -> NSFont {
    return NSFont.systemFont(ofSize: size)
}

/// 返回`指定大小`的`粗体系统字体`
/// - Parameter size: 字体大小
/// - Returns: 粗体系统字体
func boldFont(ofSize size: CGFloat) -> NSFont {
    return NSFont.boldSystemFont(ofSize: size)
}

/// 返回`指定大小`和`权重的系统字体`
/// - Parameters:
///   - size: 字体大小
///   - weight: 字体权重
/// - Returns: 指定大小和权重的系统字体
func mediumFont(ofSize size: CGFloat, weight: NSFont.Weight = .medium) -> NSFont {
    return NSFont.systemFont(ofSize: size, weight: weight)
}



/*-------------------- 快捷方法 -----------------*/

// 判断当前 app 是否是深色模式
let kAppIsDarkTheme: Bool = {
    if let appearance = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) {
        return appearance == .darkAqua
    }
    return false
}()

// 是否是沙盒模式
let kAppIsSandbox: Bool = {
    return ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
}()

// 文件路径
let kDocumentPath: String = {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
}()

/// 缓存路径
let kCachePath: String = {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
}()

// 获取资源文件路径
func kBundlePath(forResource file: String) -> String? {
    return Bundle.main.path(forResource: file, ofType: nil)
}


// App 版本号
let kAPP_Version: String = {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}()

// Build 号
let kAPP_Build_Number: String = {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
}()

// App 名称
let kAPP_Name: String = {
    // 尝试从本地化字典中获取应用名称
    let localizedName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    // 如果本地化字典中没有，尝试从非本地化字典中获取
    let displayName = localizedName ?? (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String)
    // 如果还是没有，尝试从本地化字典中获取应用名称
    return displayName ?? (Bundle.main.localizedInfoDictionary?["CFBundleName"] as? String) ?? (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
}()

// Bundle ID
let kBundle_id: String? = {
    return Bundle.main.bundleIdentifier
}()

// 系统版本号
let kSystem_OS_Version: String = {
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    return "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
}()

