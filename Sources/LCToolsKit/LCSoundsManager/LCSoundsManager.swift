//
//
//  LCSoundsManager.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//


import Foundation
import Cocoa
import AVKit

/// 声音管理器，用于处理音效和音频播放。
public class LCSoundsManager: NSObject {
    
    /// 单例模式，提供全局访问。
    public static let shared = LCSoundsManager()
    
    /// 是否正在播放
    public var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    /// 音频播放器，用于播放音效。
    private var audioPlayer: AVAudioPlayer?
    
    /// 队列播放器，用于管理播放列表或多个音频轨道。
    private var player = AVQueuePlayer()
    
    /// 播放完成回调
    private var completionHandler: (() -> Void)?
    
    /// 私有构造方法，确保外部无法直接实例化，只能使用单例 shared 访问
    private override init() {
        super.init()
    }
    
}

// MARK: - 播放通知音效
extension LCSoundsManager {
    
    /// 播放`本地音频文件`（带完成回调与循环选项）
    ///
    /// - Parameters:
    ///   - name: 文件名（不带扩展名）
    ///   - type: 扩展名（如 mp3、aiff）
    ///   - loop: 是否循环播放（true 为无限循环）
    ///   - completion: 播放完成回调（非循环情况下）
    public func playAudio(_ name: String, ofType type: String, loop: Bool = false, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            // 停止并释放旧的播放器
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            
            guard let path = Bundle.main.path(forResource: name, ofType: type) else {
                print("音频资源未找到：\(name).\(type)")
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                // 初始化音频播放器
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()   // 准备播放
                self.audioPlayer?.numberOfLoops = loop ? -1 : 0
                self.completionHandler = completion
                self.audioPlayer?.play()         // 开始播放
                print("播放音频：\(name).\(type)")
            } catch {
                print("播放音频失败：\(error.localizedDescription)")
            }
        }
    }
    
    /// 停止播放
    public func stop() {
        DispatchQueue.main.async {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
    
    /// 暂停播放
    public func pause() {
        DispatchQueue.main.async {
            self.audioPlayer?.pause()
        }
    }
    
    /// 继续播放
    public func resume() {
        DispatchQueue.main.async {
            self.audioPlayer?.play()
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension LCSoundsManager: AVAudioPlayerDelegate {
    /** ----------- 播放完成时 ----------- */
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completionHandler?()
        completionHandler = nil
    }
}
