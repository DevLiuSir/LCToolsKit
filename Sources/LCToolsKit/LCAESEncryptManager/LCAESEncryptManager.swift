//
//
//  LCAESEncryptManager.swift
//
//  Created by DevLiuSir on 2021/3/2.
//


import Foundation
import CommonCrypto
import CryptoKit



/// `AES 加密`管理器，提供 `AES 加\解密`及 `JSON 字符串`和`字典转换`的功能
public class LCAESEncryptManager {
    
    // MARK: - ECB 模式（PKCS5Padding）
    
    /// AES 加密（PKCS5Padding + ECB 模式）
    /// - Parameters:
    ///   - plainText: 明文字符串
    ///   - key: 密钥（长度需为 16、24 或 32 字节）
    /// - Returns: 加密后的 Base64 编码字符串
    public static func encryptPKCS5(_ plainText: String, withKey key: String) -> String? {
        guard let data = plainText.data(using: .utf8),
              let keyData = key.data(using: .utf8) else { return nil }
        
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = buffer.withUnsafeMutableBytes { bufferPtr in
            data.withUnsafeBytes { dataPtr in
                keyData.withUnsafeBytes { keyPtr in
                    CCCrypt(
                        CCOperation(kCCEncrypt),               // 加密模式
                        CCAlgorithm(kCCAlgorithmAES128),       // AES 算法
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode), // 填充模式 + ECB
                        keyPtr.baseAddress,                    // 密钥
                        kCCKeySizeAES128,                      // 密钥长度
                        nil,                                   // 偏移量，ECB 模式下为 nil
                        dataPtr.baseAddress,                   // 输入数据
                        data.count,                            // 输入数据长度
                        bufferPtr.baseAddress,                 // 输出缓冲区
                        bufferSize,                            // 输出缓冲区大小
                        &numBytesEncrypted                     // 加密后数据大小
                    )
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        buffer.count = numBytesEncrypted
        return buffer.base64EncodedString()
    }
    
    /// AES 解密（PKCS5Padding + ECB 模式）
    /// - Parameters:
    ///   - cipherText: 加密后的 Base64 编码字符串
    ///   - key: 密钥（长度需为 16、24 或 32 字节）
    /// - Returns: 解密后的明文字符串
    public static func decryptPKCS5(_ cipherText: String, withKey key: String) -> String? {
        guard let data = Data(base64Encoded: cipherText),
              let keyData = key.data(using: .utf8) else { return nil }
        
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = buffer.withUnsafeMutableBytes { bufferPtr in
            data.withUnsafeBytes { dataPtr in
                keyData.withUnsafeBytes { keyPtr in
                    CCCrypt(
                        CCOperation(kCCDecrypt),               // 解密模式
                        CCAlgorithm(kCCAlgorithmAES128),       // AES 算法
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode), // 填充模式 + ECB
                        keyPtr.baseAddress,                    // 密钥
                        kCCKeySizeAES128,                      // 密钥长度
                        nil,                                   // 偏移量，ECB 模式下为 nil
                        dataPtr.baseAddress,                   // 输入数据
                        data.count,                            // 输入数据长度
                        bufferPtr.baseAddress,                 // 输出缓冲区
                        bufferSize,                            // 输出缓冲区大小
                        &numBytesDecrypted                     // 解密后数据大小
                    )
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        buffer.count = numBytesDecrypted
        return String(data: buffer, encoding: .utf8)
    }
    
    
    // MARK: - ECB 解密（Data）(10.14及以下)
    
    /// 使用 AES ECB 模式解密数据
    /// - Parameters:
    ///   - data: 加密后的数据
    ///   - key: 密钥，支持长度为 16、24 或 32 字节
    /// - Returns: 解密后的明文字符串，如果解密失败返回 nil
    public static func decryptECB(data: Data, key: Data) -> String? {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES192 || key.count == kCCKeySizeAES256 else {
            print("decryptECB: invalid key length")
            return nil
        }
        
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = buffer.withUnsafeMutableBytes { bufferPtr in
            data.withUnsafeBytes { dataPtr in
                key.withUnsafeBytes { keyPtr in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                        keyPtr.baseAddress, key.count,
                        nil,
                        dataPtr.baseAddress, data.count,
                        bufferPtr.baseAddress, bufferSize,
                        &numBytesDecrypted
                    )
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else {
            print("decryptECB failed: \(cryptStatus)")
            return nil
        }
        
        return String(data: buffer.prefix(numBytesDecrypted), encoding: .utf8)
    }
    
    // MARK: - GCM 解密（CryptoKit，macOS 10.15+）
    
    /// 使用 AES GCM 模式解密数据（仅支持 macOS 10.15+）
    /// - Parameters:
    ///   - data: 加密后的数据
    ///   - key: 对称密钥
    /// - Returns: 解密后的明文字符串，如果解密失败返回 nil
    @available(macOS 10.15, *)
    public static func decryptGCM(data: Data, key: SymmetricKey) -> String? {
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let decryptedData = try? AES.GCM.open(sealedBox, using: key) else {
            print("decryptGCM failed")
            return nil
        }
        return String(data: decryptedData, encoding: .utf8)
    }
    
    
    // MARK: - 字典与 JSON 字符串转换
    
    /// 将`字典`转换为 `JSON 字符串`
    /// - Parameter dictionary: 要转换的字典
    /// - Returns: 转换后的 JSON 字符串，如果转换失败返回 nil
    public static func dictionaryToJson(_ dictionary: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// 将 `JSON 字符串`转换为`字典`
    /// - Parameter jsonString: JSON 格式的字符串
    /// - Returns: 转换后的字典，如果转换失败返回 nil
    public static func dictionaryWithJsonString(_ jsonString: String) -> [String: Any]? {
        let cleanedString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .controlCharacters)
        
        guard let jsonData = cleanedString.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
    
    
}
