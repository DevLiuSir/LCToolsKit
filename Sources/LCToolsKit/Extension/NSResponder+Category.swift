//
//  NSResponder+Category.swift
//  LCThemeKit
//
//  Created by Chuan Liu on 2023/2/19.
//

import AppKit

// 关联对象的 Key（必须使用全局静态变量 / 指针）
// Bool 仅作为占位，不影响实际存储
fileprivate var AppThemeChangedHandlerKey = false
fileprivate var AppThemeObserverKey = false
fileprivate var SystemThemeChangedHandlerKey = false
fileprivate var SystemThemeObserverKey = false

public extension NSResponder {
    
    // MARK: - 监听 “系统” 亮色 / 暗色切换
    /// 设置后，当 macOS 系统主题切换时调用：
    /// handler(self, isDark)
    ///
    /// - isDark: 系统当前是否暗色模式
    ///
    /// 自动管理 observer 生命周期，无需手动移除
    var systemThemeChangedHandler: ((NSResponder, Bool) -> Void)? {
        get {
            objc_getAssociatedObject(self, &SystemThemeChangedHandlerKey)
            as? ((NSResponder, Bool) -> Void)
        }
        set {
            objc_setAssociatedObject(self,
                                     &SystemThemeChangedHandlerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            if newValue != nil {
                // 如果开启监听，但没有 observer，则创建一个
                if objc_getAssociatedObject(self, &SystemThemeObserverKey) == nil {
                    let observer = LCThemeObserver(owner: self, observeSystem: true)
                    objc_setAssociatedObject(self,
                                             &SystemThemeObserverKey,
                                             observer,
                                             .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                // 如果置为 nil，则移除 observer
                objc_setAssociatedObject(self,
                                         &SystemThemeObserverKey,
                                         nil,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    // MARK: - 监听 “App 内部” 亮色 / 暗色切换（effectiveAppearance）
    /// 设置后，当 App 的 effectiveAppearance 变化时调用：
    /// handler(self, isDark)
    ///
    /// - isDark: App 当前是否暗色模式
    ///
    /// 自动使用 KVO 监听 NSApp.effectiveAppearance
    var appThemeChangedHandler: ((NSResponder, Bool) -> Void)? {
        get {
            objc_getAssociatedObject(self, &AppThemeChangedHandlerKey) as? ((NSResponder, Bool) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AppThemeChangedHandlerKey,newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            if newValue != nil {
                // 创建 observer
                if objc_getAssociatedObject(self, &AppThemeObserverKey) == nil {
                    let observer = LCThemeObserver(owner: self, observeApp: true)
                    objc_setAssociatedObject(self, &AppThemeObserverKey, observer,
                                             .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                // 移除 observer
                objc_setAssociatedObject(self, &AppThemeObserverKey, nil,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}



/// LCThemeObserver
/// 执行实际的系统/应用主题监听逻辑
/// NSResponder 仅负责暴露 API，不负责监听
private class LCThemeObserver: NSObject {
    
    /// 持有者（NSResponder）
    weak var owner: NSResponder?
    
    /// 是否监听系统主题变化（DistributedNotification）
    private var observeSystem: Bool
    
    /// 是否监听 app 内部主题变化（KVO）
    private var observeApp: Bool
    
    private var kvoContext = 0
    
    
    /// 初始化观察者
    ///
    /// - Parameters:
    ///   - owner: 需要监听主题变化的目标对象，一般为 `self`
    ///   - observeSystem: 是否监听系统整体的浅色｜深色切换事件
    ///   - observeApp: 是否监听 App 内部 appearance 变化事件（通常较少用）
    init(owner: NSResponder, observeSystem: Bool = false, observeApp: Bool = false) {
        self.owner = owner
        self.observeSystem = observeSystem
        self.observeApp = observeApp
        super.init()
        
        // 监听系统主题变化（菜单栏切换、快捷键切换等）
        if observeSystem {
            DistributedNotificationCenter.default().addObserver(
                self, selector: #selector(systemNotification),
                name: NSNotification.Name("AppleInterfaceThemeChangedNotification"), object: nil)
        }
        
        // 监听 App 内部主题变化（窗口 Appearance 修改等）
        if observeApp {
            NSApp.addObserver(self, forKeyPath: "effectiveAppearance", options: [.new], context: &kvoContext)
        }
    }
    
    
    // MARK: - 销毁
    deinit {
        if observeSystem {
            DistributedNotificationCenter.default().removeObserver(self)
        }
        if observeApp {
            NSApp.removeObserver(self, forKeyPath: "effectiveAppearance", context: &kvoContext)
        }
    }
    
    
    // MARK: - 系统主题切换通知
    @objc private func systemNotification() {
        guard observeSystem, let owner = owner else { return }
        owner.systemThemeChangedHandler?(owner, systemIsDarkTheme)
    }
    
    
    // MARK: - KVO：App 内部主题切换
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard observeApp, let owner = owner else { return }
        if keyPath == "effectiveAppearance" {
            owner.appThemeChangedHandler?(owner, appIsDarkTheme)
        }
    }
    
    
    // MARK: - 判断 App 是否暗色
    private var appIsDarkTheme: Bool {
        return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
    
    // MARK: - 判断系统是否暗色（读取全局 UserDefaults）
    private var systemIsDarkTheme: Bool {
        let info = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)
        if let style = info?["AppleInterfaceStyle"] as? String {
            return style.caseInsensitiveCompare("dark") == .orderedSame
        }
        return false
    }
}
