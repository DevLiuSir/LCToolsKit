//
//  LCStatusItemPositionManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation


/// 管理 NSStatusItem 在菜单栏中的显示位置（是否靠右）
final class LCStatusItemPositionManager {

    /// 默认使用的 UserDefaults 键（针对第一个状态栏项）
    private static let preferredPositionKey = "NSStatusItem Preferred Position Item-0"
    
    
    /*
     使用 UserDefaults 设置系统菜单栏图标（NSStatusItem）的首选位置。

     在 macOS 中，菜单栏图标的排列顺序是可以由系统或用户决定的。
     每个状态栏图标都可以通过一个 key 写入 UserDefaults 来设置它的“优先位置”。

     示例：
     - 将状态栏项 0 的首选位置设置为 50：
         UserDefaults.standard.set(50, forKey: "NSStatusItem Preferred Position Item-0")

     含义：
     - 数值越小，图标越靠近屏幕右上角（更靠近控制中心、Spotlight 等系统图标）。
     - 设置为 50，通常会让你的 App 图标排在“不能手动拖动的系统图标”前面，即最右侧靠前的位置。

     注意事项：
     - 设置后通常在 App 下次启动时生效。
     - 有时需要强制刷新 UserDefaults（重新写入当前值）以确保 UI 更新。
    */
    

    /// 系统默认菜单栏图标“靠右”的位置值（示例值，可自定义）
    private static let preferredRightPositionValue = 50
    
    
    /// 检查当前状态栏图标是否靠右（只读属性）
    public static var isRightMost: Bool {
        let currentValue = UserDefaults.standard.integer(forKey: preferredPositionKey)
        let result = currentValue == preferredRightPositionValue
#if DEBUG
        NSLog("🔍 当前状态栏图标位置值为 \(currentValue)，是否靠右：\(result)")
#endif
        return result
    }
    
    
    /// 设置菜单栏图标靠右显示（紧挨控制中心）
    public static func setStatusItemToRightMostPosition() {
        UserDefaults.standard.set(preferredRightPositionValue, forKey: preferredPositionKey)
        UserDefaults.standard.synchronize()
#if DEBUG
        NSLog("✅ 设置状态栏图标靠右显示，UserDefaults[\(preferredPositionKey)] = \(preferredRightPositionValue)")
#endif
    }
    

    /// 重置图标位置（取消偏移）
    public static func resetStatusItemPosition() {
        UserDefaults.standard.removeObject(forKey: preferredPositionKey)
        UserDefaults.standard.synchronize()
#if DEBUG
        NSLog("🔄 已重置状态栏图标位置，移除 UserDefaults[\(preferredPositionKey)]")
#endif
    }
    
}
