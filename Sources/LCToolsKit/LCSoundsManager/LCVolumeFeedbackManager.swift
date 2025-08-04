//
//  LCVolumeFeedbackManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//

import Foundation
import AudioToolbox
import AVFoundation
import CoreAudio
import CoreFoundation


/// 管理系统警告音量的类
class LCVolumeFeedbackManager {
    
    /// 存储原来的系统警告音量
    private static var originalVolume: Float = 0.0
    
    /// 标记是否修改过音量
    private static var isVolumeMuted: Bool = false
    
    
    //MARK: 系统音效
    
    /// 获取系统音量
    /// - Returns: 当前系统音量值，如果获取失败则返回 nil
    static func getSystemVolume() -> Float? {
        // 获取默认输出设备的 ID
        var defaultOutputDeviceID = AudioObjectID(kAudioObjectSystemObject)
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice, // 属性选择器：默认输出设备
            mScope: kAudioObjectPropertyScopeGlobal, // 范围：全局
            mElement: kAudioObjectPropertyElementMaster // 元素：主元素
        )
        
        // 获取属性数据的大小
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        // 获取默认输出设备 ID
        let status = AudioObjectGetPropertyData(defaultOutputDeviceID, &propertyAddress, 0, nil, &size, &defaultOutputDeviceID)
        
        if status != noErr {
            NSLog("Error getting default output device: \(status)")
            return nil
        }
        
        // 配置属性地址以获取音量
        propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar, // 属性选择器：音量比例
            mScope: kAudioDevicePropertyScopeOutput, // 范围：输出
            mElement: kAudioObjectPropertyElementMaster // 元素：主元素
        )
        
        // 获取音量的大小
        var volume: Float = 0
        size = UInt32(MemoryLayout<Float>.size)
        // 获取系统音量
        let volumeStatus = AudioObjectGetPropertyData(defaultOutputDeviceID, &propertyAddress, 0, nil, &size, &volume)
        
        if volumeStatus != noErr {
            NSLog("Error getting system volume: \(volumeStatus)")
            return nil
        }
        
        return volume
    }
    
    /// 设置`系统音量`
    /// - Parameter volume: 要设置的音量值，范围应在 0.0 到 1.0 之间
    static func setSystemVolume(_ volume: Float) {
        // 获取默认输出设备的 ID
        var defaultOutputDeviceID = AudioObjectID(kAudioObjectSystemObject)
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice, // 属性选择器：默认输出设备
            mScope: kAudioObjectPropertyScopeGlobal, // 范围：全局
            mElement: kAudioObjectPropertyElementMaster // 元素：主元素
        )
        
        // 获取属性数据的大小
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        // 获取默认输出设备 ID
        let status = AudioObjectGetPropertyData(defaultOutputDeviceID, &propertyAddress, 0, nil, &size, &defaultOutputDeviceID)
        
        if status != noErr {
            NSLog("Error getting default output device: \(status)")
            return
        }
        
        // 配置属性地址以设置音量
        propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar, // 属性选择器：音量比例
            mScope: kAudioDevicePropertyScopeOutput, // 范围：输出
            mElement: kAudioObjectPropertyElementMaster // 元素：主元素
        )
        
        // 要设置的新音量值
        var newVolume = volume
        // 设置系统音量
        let volumeStatus = AudioObjectSetPropertyData(defaultOutputDeviceID, &propertyAddress, 0, nil, UInt32(MemoryLayout<Float>.size), &newVolume)
        
        if volumeStatus != noErr {
            NSLog("Error setting system volume: \(volumeStatus)")
        }
    }
    
    
    //MARK: 警告音效
    
    /// 系统警告音量的属性 ID
    static let kAudioServicesPropertySystemAlertVolume: AudioServicesPropertyID = UInt32(bitPattern: Int32("ssvl".fourCharCode))
    
    /// 获取当前`系统警告音量`
    /// - Returns: 返回当前警告音量（Float），如果获取失败则返回 nil
    static func getSystemAlertVolume() -> Float? {
        var volume: Float = 0
        var volSize = UInt32(MemoryLayout.size(ofValue: volume))
        let err = AudioServicesGetProperty(kAudioServicesPropertySystemAlertVolume, 0, nil, &volSize, &volume)
        
        // 如果获取音量时出错，打印错误信息并返回 nil
        if err != noErr {
            NSLog("Failed to get alert volume with error \(err)")
            return nil
        }
        // 返回获取的音量
        return volume
    }
    
    /// 设置`系统警告音量`
    /// - Parameter volume: 要设置的音量值
    static func setSystemAlertVolume(to volume: Float32) {
        var mutableVolume = volume
        AudioServicesSetProperty(kAudioServicesPropertySystemAlertVolume, 0, nil, UInt32(MemoryLayout.size(ofValue: mutableVolume)),&mutableVolume)
    }
    
    /// `禁用`系统警告音量
    static func muteSystemAlertVolume() {
        guard !isVolumeMuted else { return } // 防止重复操作
        
        if let currentVolume = getSystemAlertVolume(), currentVolume > 0 {
            originalVolume = currentVolume
            setSystemAlertVolume(to: 0) // 设置为静音
            isVolumeMuted = true
            print("已禁用系统警告音量")
        }
    }
    
    /// `恢复`系统警告音量
    static func restoreSystemAlertVolume() {
        guard isVolumeMuted else { return } // 只有在被修改后才恢复
        setSystemAlertVolume(to: originalVolume) // 恢复原音量
        isVolumeMuted = false
        print("提醒音量已恢复为:\(originalVolume)")
    }
}


extension String {
    /// 将字符串转换为四字符代码（FourCharCode）
    /// - 该属性将字符串的每个字符（以 UTF-8 编码表示）转换为一个 32 位整数，
    ///   并按照四字符代码的格式排列。
    /// - Example: 字符串 "abcd" 会被转换为对应的 FourCharCode 值。
    public var fourCharCode: FourCharCode {
        var result: FourCharCode = 0
        for character in utf8 {
            // 将当前的结果左移8位，然后加上当前字符的值，形成四字符代码
            result = (result << 8) + FourCharCode(character)
        }
        return result
    }
}
