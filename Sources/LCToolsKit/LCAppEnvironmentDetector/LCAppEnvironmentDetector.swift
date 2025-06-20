//
//  LCAppEnvironmentDetector.swift
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation
import Security


/// App环境检测器（用于判断当前App的运行环境）
public struct LCAppEnvironmentDetector {
    
    /// 单例实例
    public static let shared = LCAppEnvironmentDetector()
    private init() {}
    
    /// 获取当前App的运行环境
    public func currentEnvironment() -> LCAppRunEnvironment {
        
        // 非沙盒（无沙盒容器ID）
        guard let _ = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] else {
            print("当前App环境: 非沙盒环境")
            return .nonSandbox
        }
        
        // 若收据文件不存在，视为开发环境
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: receiptURL.path) else {
            print("当前App环境: 开发环境（无收据）")
            return .development
        }
        
        // 获取收据静态代码签名信息
        var staticCode: SecStaticCode?
        let status = SecStaticCodeCreateWithPath(receiptURL as CFURL, [], &staticCode)
        guard status == errSecSuccess, let code = staticCode else {
            print("当前App环境: 开发环境（签名信息无效）")
            return .development
        }
        
        // 判断是否为 App Store 签名
        if codeSignatureContainsOID(code, oid: "1.2.840.113635.100.6.11.1") {
            print("当前App环境: App Store")
            return .appStore
        }
        
        // 判断是否为 TestFlight 签名
        if codeSignatureContainsOID(code, oid: "1.2.840.113635.100.6.1.25") {
            print("当前App环境: TestFlight")
            return .testFlight
        }
        
        // 默认视为开发环境
        print("当前App环境: 开发环境（未匹配OID）")
        return .development
    }
    
    /// 检查静态代码签名是否包含指定OID（签名用途标识）
    ///
    /// - Parameters:
    ///   - code: 静态代码对象
    ///   - oid: 签名中的OID（对象标识符）
    /// - Returns: 是否包含该OID
    private func codeSignatureContainsOID(_ code: SecStaticCode, oid: String) -> Bool {
        var requirement: SecRequirement?
        let requirementString = "certificate leaf[\(oid)] exists" as CFString
        
        guard SecRequirementCreateWithString(requirementString, [], &requirement) == errSecSuccess,
              let req = requirement else {
            return false
        }
        
        // 校验签名是否符合要求
        return SecStaticCodeCheckValidity(code, [], req) == errSecSuccess
    }
}
