//
//
//  LCWallpaperManager.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import AppKit

/// 管理桌面壁纸设置的工具类
public class LCWallpaperManager {
    
    /// 设置主屏幕壁纸
    /// - Parameter imageURL: 要设置的壁纸图片 URL（可选）
    public static func setWallpaper(with imageURL: URL?) {
        guard let imageURL = imageURL else {
            print("❌ 无效的图片 URL，壁纸设置失败")
            return
        }
        guard let screen = NSScreen.main else {
            print("❌ 无法获取主屏幕")
            return
        }
        setWallpaper(imageURL: imageURL, for: screen)
    }
    
    /// 为`指定屏幕`设置壁纸
    /// - Parameters:
    ///   - imageURL: 壁纸图片 URL
    ///   - screen: 目标屏幕
    public static func setWallpaper(imageURL: URL, for screen: NSScreen) {
        do {
            try NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
            print("✅ 壁纸设置成功：\(imageURL.path) -> \(screen.localizedName)")
        } catch {
            print("❌ 设置壁纸失败：\(error)")
        }
    }
    
    /// 为`所有屏幕`设置`统一的壁纸`
    /// - Parameter imageURL: 壁纸图片 URL
    public static func setWallpaperForAllScreens(with imageURL: URL) {
        for screen in NSScreen.screens {
            setWallpaper(imageURL: imageURL, for: screen)
        }
    }
    
    /// 获取当前主屏幕的壁纸 URL
    /// - Returns: 当前壁纸的 URL
    public static func getCurrentWallpaperURL() -> URL? {
        guard let screen = NSScreen.main else {
            print("❌ 无法获取主屏幕")
            return nil
        }
        return NSWorkspace.shared.desktopImageURL(for: screen)
    }
    
}
