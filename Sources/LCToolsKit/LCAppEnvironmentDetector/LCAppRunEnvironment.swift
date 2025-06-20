//
//  LCAppRunEnvironment.swift
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation

/// App运行环境类型
public enum LCAppRunEnvironment {
    case appStore       // App Store 正式发布版本
    case testFlight     // TestFlight 测试版本
    case development    // 开发/企业签名版本
    case nonSandbox     // 非沙盒环境（通常是调试或命令行工具）
}
