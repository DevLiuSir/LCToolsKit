//
//  LCSpeechManager.swift
//  LCSpeechManager
//
//  Created by DevLiuSir on 2021/6/24.
//
import Foundation
import AppKit

/// 负责处理`语音输出`的管理类
public class LCSpeechManager {
    
    // 单例语音合成器实例
    private static let synthesizer = NSSpeechSynthesizer()
    
    
    
    /// 使用 `say 命令语音`输出`指定内容`
    /// - Parameter message: 要说出的内容
    public class func speak(message: String) {
        let sayCommand = "/usr/bin/say"
        let task = Process()
        task.launchPath = sayCommand
        task.arguments = [message]
        
        task.launch()
        task.waitUntilExit()
    }
    
    
    
    /**
     使用系统默认语音将所选文本大声读出来，您可以使用 NSSpeechSynthesizer 类。
     NSSpeechSynthesizer 是 AppKit 框架中的一个类，可用于进行文本到语音的转换。
     
     要更改声音，请转到系统偏好设置中的“语音”。
     */
    public static func speakSelectedText(_ string: String) {
        // 停止当前朗读
        stopSpeaking()
        
        // 使用 "Mei-Jia" 语音标识符，这是支持中文的一种语音
        let voiceIdentifier = "com.apple.speech.synthesis.voice.meijia"
        
        // 设置语音合成器使用的语音
        synthesizer.setVoice(NSSpeechSynthesizer.VoiceName(rawValue: voiceIdentifier))
        // 开始朗读文本
        synthesizer.startSpeaking(string)
    }
    
    
    /// `停止朗读`当前`正在进行的语音输出`
    public static func stopSpeaking() {
        // 停止朗读
        synthesizer.stopSpeaking()
    }
    
    
}
