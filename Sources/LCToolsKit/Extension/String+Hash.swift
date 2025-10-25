//
//  String+Hash.swift
//
//  Created by DevLiuSir on 2021/3/2.
//

import Foundation
import CryptoKit
import CommonCrypto



// MARK: - String + Hash 扩展
public extension String {
    
    // MARK: - MD5
    
    /// 计算字符串的 **MD5 小写** 哈希值。
    ///
    /// 示例：
    /// ```swift
    /// "hello".md5Lower   // "5d41402abc4b2a76b9719d911017c592"
    /// ```
    var md5Lower: String {
        if #available(macOS 10.15, *) {
            guard let data = data(using: .utf8) else { return "" }
            let digest = Insecure.MD5.hash(data: data)
            return digest.map { String(format: "%02x", $0) }.joined()
        } else {
            guard let data = data(using: .utf8) else { return "" }
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            data.withUnsafeBytes { bytes in
                _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
    }
    
    /// 计算字符串的 **MD5 大写** 哈希值。
    ///
    /// 示例：
    /// ```swift
    /// "hello".md5Upper   // "5D41402ABC4B2A76B9719D911017C592"
    /// ```
    var md5Upper: String {
        if #available(macOS 10.15, *) {
            guard let data = data(using: .utf8) else { return "" }
            let digest = Insecure.MD5.hash(data: data)
            return digest.map { String(format: "%02X", $0) }.joined()
        } else {
            guard let data = data(using: .utf8) else { return "" }
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            data.withUnsafeBytes { bytes in
                _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02X", $0) }.joined()
        }
    }
    
    // MARK: - SHA 系列
    
    /// 计算字符串的 **SHA-1 哈希值**。
    ///
    /// - Returns: 40 位十六进制字符串。
    var sha1: String {
        guard let data = data(using: .utf8) else { return "" }
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    /// 计算字符串的 **SHA-256 哈希值**。
    ///
    /// - Returns: 64 位十六进制字符串。
    var sha256: String {
        if #available(macOS 10.15, *) {
            let data = Data(self.utf8)
            let hashed = SHA256.hash(data: data)
            return hashed.map { String(format: "%02x", $0) }.joined()
        } else {
            guard let data = data(using: .utf8) else { return "" }
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
    }
    
    /// 计算字符串的 **SHA-512 哈希值**。
    ///
    /// - Returns: 128 位十六进制字符串。
    var sha512: String {
        if #available(macOS 10.15, *) {
            let data = Data(self.utf8)
            let hashed = SHA512.hash(data: data)
            return hashed.map { String(format: "%02x", $0) }.joined()
        } else {
            guard let data = data(using: .utf8) else { return "" }
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
    }
    
    // MARK: - Base64 编码
    
    /// 将字符串编码为 Base64。
    ///
    /// - Returns: Base64 编码字符串。
    var base64Encoded: String {
        guard let data = data(using: .utf8) else { return "" }
        return data.base64EncodedString()
    }
    
    /// 从 Base64 字符串解码。
    ///
    /// - Returns: 解码后的原始字符串。
    var base64Decoded: String {
        guard let data = Data(base64Encoded: self),
              let decoded = String(data: data, encoding: .utf8)
        else { return "" }
        return decoded
    }
}
