//
//  LCSpeechManager.swift
//  LCSpeechManager
//
//  Created by DevLiuSir on 2021/6/24.
//
    

import Foundation

/// 负责处理`语音输出`的管理类
public class LCSpeechManager {
    
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
    
}
