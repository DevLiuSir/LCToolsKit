//
//  LCAppRunEnvironment.swift
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation

/// App运行环境类型
public enum LCAppRunEnvironment: String {
    /// app store 线上
    case appStore       = "App store"
    /// testFlight 测试
    case testFlight     = "TestFlight"
    /// 线下分发的Apple公证过的app
    case developerID    = "Developer ID"
    /// 特定人群的测试版本
    case adHoc          = "Ad Hoc"
    /// 开发调试
    case development    = "Development"
    // 未知版本或苹果审核
    case other          = "Other"
}
