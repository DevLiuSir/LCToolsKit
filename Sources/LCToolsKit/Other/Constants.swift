//
//  Constants.swift
//
//  Created by Liu Chuan on 2024/7/30.
//

/*-------------------- 数据类型转换 -----------------*/
import Cocoa
import Carbon

// Int 转换为字符串
public func stringFromInt(_ int: Int) -> String {
    return "\(int)"
}

// UInt 转换为字符串
public func stringFromUInt(_ uint: UInt) -> String {
    return "\(uint)"
}

// Int 转换为字符串
public func stringFromInteger(_ integer: Int) -> String {
    return "\(integer)"
}

// UInt 转换为字符串
public func stringFromUInteger(_ uinteger: UInt) -> String {
    return "\(uinteger)"
}

// Float 转换为字符串
public func stringFromFloat(_ float: Float) -> String {
    return "\(float)"
}

// Float 转换为价格格式的字符串，保留两位小数
public func stringFromFloatPrice(_ float: Float) -> String {
    return String(format: "%.2f", float)
}

/*-------------------- 屏幕 -----------------*/

// 屏幕的缩放因子
public let kScreenScale: CGFloat = {
    return NSScreen.main?.backingScaleFactor ?? 1.0
}()

// 屏幕的宽度
public let kScreenWidth: CGFloat = {
    return NSScreen.main?.frame.size.width ?? 0.0
}()

// 屏幕的高度
public let kScreenHeight: CGFloat = {
    return NSScreen.main?.frame.size.height ?? 0.0
}()

// 状态栏的高度
public let kStatusBarHeight: CGFloat = {
    return NSApp.mainMenu?.menuBarHeight ?? 0.0
}()

/*-------------------- 字体 -----------------*/

/// 返回`指定大小`的`系统字体`
/// - Parameter size: 字体大小
/// - Returns: 系统字体
public func font(ofSize size: CGFloat) -> NSFont {
    return NSFont.systemFont(ofSize: size)
}

/// 返回`指定大小`的`粗体系统字体`
/// - Parameter size: 字体大小
/// - Returns: 粗体系统字体
public func boldFont(ofSize size: CGFloat) -> NSFont {
    return NSFont.boldSystemFont(ofSize: size)
}

/// 返回`指定大小`和`权重的系统字体`
/// - Parameters:
///   - size: 字体大小
///   - weight: 字体权重
/// - Returns: 指定大小和权重的系统字体
public func mediumFont(ofSize size: CGFloat, weight: NSFont.Weight = .medium) -> NSFont {
    return NSFont.systemFont(ofSize: size, weight: weight)
}


// MARK: - app相关信息

// 是否是沙盒模式
public let kAppIsSandbox: Bool = {
    return ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
}()

// 判断当前 app 是否是深色模式
public let kAppIsDarkTheme: Bool = {
    if let appearance = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) {
        return appearance == .darkAqua
    }
    return false
}()

// 判断系统是否为暗黑模式
public var kSystemIsDarkTheme: Bool {
    let info = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)
    if let style = info?["AppleInterfaceStyle"] as? String {
        return style.caseInsensitiveCompare("dark") == .orderedSame
    }
    return false
}


// 文件路径
public let kDocumentPath: String = {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
}()

/// 缓存路径
public let kCachePath: String = {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
}()

// 获取资源文件路径
public func kBundlePath(forResource file: String) -> String? {
    return Bundle.main.path(forResource: file, ofType: nil)
}

// App 版本号
public let kAPP_Version: String = {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}()

// Build 号
public let kAPP_Build_Number: String = {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
}()

// App 名称
public let kAPP_Name: String = {
    // 尝试从本地化字典中获取应用名称
    let localizedName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    // 如果本地化字典中没有，尝试从非本地化字典中获取
    let displayName = localizedName ?? (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String)
    // 如果还是没有，尝试从本地化字典中获取应用名称
    return displayName ?? (Bundle.main.localizedInfoDictionary?["CFBundleName"] as? String) ?? (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
}()

// Bundle ID
public let kBundle_id: String? = {
    return Bundle.main.bundleIdentifier
}()

// 系统版本号
public let kSystem_OS_Version: String = {
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    return "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
}()


// MARK: - 修饰键判断的相关方法

// 修饰键掩码
public let MODIFIER_MASK: NSEvent.ModifierFlags = [.shift, .control, .option, .command]

// MARK: 判断是否是快捷键的修饰键
public func isModifierFlags(_ flags: NSEvent.ModifierFlags) -> Bool {
    let allowedCombinations: [NSEvent.ModifierFlags] = [
        .shift,
        .option,
        .command,
        .control,
        [.shift, .control],
        [.shift, .control, .option],
        [.shift, .control, .option, .command],
        [.shift, .control, .command],
        [.shift, .option],
        [.shift, .option, .command],
        [.shift, .command],
        [.control, .option],
        [.control, .option, .command],
        [.control, .command],
        [.option, .command],
    ]
    for combo in allowedCombinations {
        if ModifierFlagsEqual(flags, combo) {
            return true
        }
    }
    return false
}

// MARK: 是否是Contorl修饰键
public func IsControlModifierFlags(_ flags: NSEvent.ModifierFlags) -> Bool {
    MODIFIER_MASK.rawValue & flags.rawValue == NSEvent.ModifierFlags.control.rawValue
}

// MARK: 是否是Shift修饰键
public func IsShiftModifierFlags(_ flags: NSEvent.ModifierFlags) -> Bool {
    MODIFIER_MASK.rawValue & flags.rawValue == NSEvent.ModifierFlags.shift.rawValue
}

// MARK: 是否是Command修饰键
public func IsCommandModifierFlags(_ flags: NSEvent.ModifierFlags) -> Bool {
    MODIFIER_MASK.rawValue & flags.rawValue == NSEvent.ModifierFlags.command.rawValue
}

// MARK: 是否是Option修饰键
public func IsOptionModifierFlags(_ flags: NSEvent.ModifierFlags) -> Bool {
    MODIFIER_MASK.rawValue & flags.rawValue == NSEvent.ModifierFlags.option.rawValue
}

// MARK: 2个修饰键是否相同
public func ModifierFlagsEqual(_ flags: NSEvent.ModifierFlags, _ anotherFlags: NSEvent.ModifierFlags) -> Bool {
    (MODIFIER_MASK.rawValue & flags.rawValue) != 0 &&
    (MODIFIER_MASK.rawValue & anotherFlags.rawValue) != 0 &&
    (MODIFIER_MASK.rawValue & flags.rawValue) == (MODIFIER_MASK.rawValue & anotherFlags.rawValue)
}

// MARK: 一个修饰键是否包含另一个修饰键
public func ModifierFlagsContain(_ flags: NSEvent.ModifierFlags, _ containedFlags: NSEvent.ModifierFlags) -> Bool {
    flags.rawValue & containedFlags.rawValue == containedFlags.rawValue
}


// MARK: - 修饰键根据按键值判断

public func IsControlKeyCode(_ keyCode: CGKeyCode) -> Bool { keyCode == kVK_Control || keyCode == kVK_RightControl }
public func IsShiftKeyCode(_ keyCode: CGKeyCode) -> Bool { keyCode == kVK_Shift || keyCode == kVK_RightShift }
public func IsCommandKeyCode(_ keyCode: CGKeyCode) -> Bool { keyCode == kVK_Command || keyCode == kVK_RightCommand }
public func IsOptionKeyCode(_ keyCode: CGKeyCode) -> Bool { keyCode == kVK_Option || keyCode == kVK_RightOption }

// MARK: - CGEventFlags 和 NSEventModifierFlags 转换

// MARK: 将 CGEventFlags 转成 NSEventModifierFlags
public func NSEventModifierFlagsFromCGEventFlags(_ cgFlags: CGEventFlags) -> NSEvent.ModifierFlags {
    var nsFlags: NSEvent.ModifierFlags = []
    if cgFlags.contains(.maskShift) {
        nsFlags.insert(.shift)
    }
    if cgFlags.contains(.maskControl) {
        nsFlags.insert(.control)
    }
    if cgFlags.contains(.maskAlternate) {
        nsFlags.insert(.option)
    }
    if cgFlags.contains(.maskCommand) {
        nsFlags.insert(.command)
    }
    return nsFlags
}

// MARK: 比较 CGEventFlags 和 NSEventModifierFlags 是否相同
public func CGEventFlagsEqualToModifierFlags(_ cgFlags: CGEventFlags, _ nsFlags: NSEvent.ModifierFlags) -> Bool { NSEventModifierFlagsFromCGEventFlags(cgFlags) == nsFlags }

// MARK: 事件的修饰键 == nsFlags
public func CGEventMatchesModifierFlags(_ event: CGEvent, _ nsFlags: NSEvent.ModifierFlags) -> Bool { CGEventFlagsEqualToModifierFlags(event.flags, nsFlags) }
