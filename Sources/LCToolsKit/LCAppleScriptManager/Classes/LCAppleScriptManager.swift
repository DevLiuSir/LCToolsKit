//
//  LCAppleScriptManager.swift
//
//  Created by DevLiuSir on 2023/8/18.
//

import Foundation
import Cocoa
import AppKit
import Carbon



/// 本地化字符串的函数
/// - Parameter key: 要本地化的字符串键
/// - Returns: 对应的本地化字符串，如果未找到则返回原始键
fileprivate func LCAppleScriptLocalizeString(_ key: String) -> String {
    // 使用静态变量以确保只创建一次
    var bundle: Bundle?
    var onceToken: Int = 0
    
    // 确保线程安全
    // 检查一次标记以防止多次创建
    if onceToken == 0 {
        onceToken = 1
        // 获取LCAppSandboxFileKit的bundle
        bundle = Bundle(for: LCAppleScriptManager.self)
    }
    
    // 使用指定的键从bundle中获取本地化字符串
    // 如果未找到，返回原始键
    return bundle?.localizedString(forKey: key, value: "", table: "LCAppleScriptManager") ?? key
}



/// 应用程序的显示名称
fileprivate let KApplicationName: String = {
    // 获取主应用程序的 Bundle
    let mainBundle = Bundle.main
    
    // 尝试从不同的字典中获取应用程序的显示名称
    let appName = mainBundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
        ?? mainBundle.infoDictionary?["CFBundleDisplayName"] as? String
        ?? mainBundle.localizedInfoDictionary?["CFBundleName"] as? String
        ?? mainBundle.infoDictionary?["CFBundleName"] as? String

    // 如果所有方法都未能获取到应用程序名称，则返回默认值
    return appName ?? "默认应用程序名称" // 提供一个默认值
}()




/// AppleScript脚本管理员
public class LCAppleScriptManager {
    
    /// 单例
    static var shared = LCAppleScriptManager()
    
    /// 定义一个全局变量，用于控制弹窗显示状态
    var isAlertShowing = false
    
    /// 弹出框消息
    public static var alertMessages = ""

    /// 弹出框详细信息
    public static var alertInfomative = ""

    /// 安装警告
    public static var alertInstall = ""

    /// 取消警告
    public static var alertCancel = ""

    /// 面板提示
    public static var panelPrompt = ""

    /// 面板消息
    public static var panelMessage = ""
    
    
    init() {
        LCAppleScriptManager.alertMessages = LCAppleScriptLocalizeString("appleScript.alert.messageText")
        LCAppleScriptManager.alertInfomative = LCAppleScriptLocalizeString("appleScript.alert.informativeText")
        LCAppleScriptManager.alertInstall = LCAppleScriptLocalizeString("appleScript.alert.install")
        LCAppleScriptManager.alertCancel = LCAppleScriptLocalizeString("appleScript.alert.cancel")
        LCAppleScriptManager.panelPrompt = LCAppleScriptLocalizeString("openPanel.prompt")
        LCAppleScriptManager.panelMessage = LCAppleScriptLocalizeString("openPanel.message")
    }
    
    
    //MARK: - 线下版本
    /// 执行`应用程序包内`的`AppleScript`
    ///
    /// - Parameters:
    ///   - fileName: AppleScript文件名
    ///   - funcName: 要执行的函数名，可选
    ///   - arguments: 函数参数数组，可选
    ///   - handler: 完成时的处理程序，可选
    static func executeAppleScriptInAppBundle(_ fileName: String, funcName: String?, arguments: [String]?, handler: NSUserAppleScriptTask.CompletionHandler?) {
        // 检查`AppleScript脚本文件`是否存在
        guard let scriptUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("脚本文件不存在: \(fileName)")
            return
        }

        // 在全局队列中异步执行
        DispatchQueue.global().async {
            // 初始化 AppleScript 对象
            let appleScript = NSAppleScript(contentsOf: scriptUrl, error: nil)
            
            // 创建事件描述符
            let descriptor = createEventDescriptor(with: funcName!, arguments: arguments!)
            
            var error: NSDictionary?
            //MARK: - 使用此方法，可以隐藏 执行 AppleScript时，状态栏的齿轮图标
            // 执行 AppleScript
            let result = appleScript?.executeAppleEvent(descriptor!, error: &error)
            
            // 打印结果
            //print("AppleScript 执行结果: \(String(describing: result))")
            
            // 在主队列中异步执行
            DispatchQueue.main.async {
                if let handler = handler {
                    if let result = result {
                        // 处理结果
                        handler(result, nil)
                    } else {
                        // 处理错误
                        let posixError = NSError(domain: NSPOSIXErrorDomain, code: 2, userInfo: error as? [String: Any])
                        handler(nil, posixError)
                    }
                }
            }
        }
    }

    
    /// 检查 和 安装 多个`AppleScript`脚本
    /// - Parameter scriptNames: 多个脚本文件名，
    /// - Returns: 是否已安装： TRUE、FALSE
    static func checkAndInstallScripts(scriptNames: [String]) -> Bool {
        // 获取默认的文件管理器实例
        let fileManager = FileManager.default
        
        var allScriptsInstalled = true
        //遍历所有脚本名称，检查每一个脚本是否都安装
        for scriptName in scriptNames {
            do {
                // 尝试获取应用脚本目录的URL
                let directoryURL = try fileManager.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                // 创建目标脚本文件的URL
                let destinationURL = directoryURL.appendingPathComponent(scriptName)
                
                // 检查脚本文件是否已经存在
                if !fileManager.fileExists(atPath: destinationURL.path) {
                    // 如果脚本文件不存在，执行安装
                    print("\(scriptName) 脚本文件尚未安装。")
                    
                    // 调用安装脚本的方法
                    LCAppleScriptManager.installScriptsWithArr(scriptNames) { result in
                        if result {
                            print("\(scriptName) 脚本文件安装成功")
                        } else {
                            print("\(scriptName) 脚本文件安装失败")
                        }
                    }
                    allScriptsInstalled = false
                } else {
                    // 如果脚本文件已经存在，打印相应消息
                    print("\(scriptName) 脚本已经安装。")
                }
            } catch {
                // 如果在获取应用脚本目录时发生错误，打印错误消息
                print("获取应用脚本目录时发生错误：", error)
                allScriptsInstalled = false
            }
        }
        
        return allScriptsInstalled
    }
    
    
    
    /// 获取 `APP 脚本目录`的URL
    /// - Returns: 返回脚本目录的URL，如果发生错误则返回nil
    static func getScriptLocalURL() -> URL? {
        var url: URL?
        
        // 创建一个信号量，用于等待后台任务完成
        let semaphore = DispatchSemaphore(value: 0)
        
        // 在全局队列中异步执行任务
        DispatchQueue.global().async {
            var error: NSError?
            
            // 尝试获取应用程序脚本目录的URL
            url = try? FileManager.default.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // 如果发生错误，记录错误信息
            if let error = error {
                print("【\(#function)】 error: \(error)")
            }
            
            // 释放信号量，以通知主线程任务已完成
            semaphore.signal()
        }
        
        // 等待信号量，最多等待2秒钟
        _ = semaphore.wait(timeout: .now() + 2)
        
        // 返回应用程序脚本目录的URL（可能为nil）
        return url
    }
    
    
    /// 检查`脚本文件`是否`已安装`
    /// - Parameter fileName: 要检查的脚本文件的名称
    /// - Returns: 如果文件已存在，则返回true；否则返回false
    public static func scriptFileHasInstalled(fileName: String) -> Bool {
       
        // 检查文件名是否为NSString类型且非空
        if !((fileName as AnyObject).isKind(of: NSString.self)) || fileName.isEmpty {
            return false
        }
        
        // 获取应用程序脚本目录的URL
        guard let scriptDirUrl = getScriptLocalURL() else {
            return false
        }
        
        // 构建目标文件的URL，将脚本文件名附加到脚本目录的URL后面
        let destionationUrl = scriptDirUrl.appendingPathComponent(fileName)
        
        // 检查文件是否存在于目标URL
        return FileManager.default.fileExists(atPath: destionationUrl.path)
    }
    
    
    /// 执行脚本文件内的函数，如果本地不存在，从项目内copy到本地再执行
    /// 适用于一个脚本文件内，包含多个脚本，传入脚本名称，来调用脚本指令
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - func: 脚本函数名
    ///   - arguments: 传入的参数
    ///   - descType: 返回值类型
    ///   - handler: 结果回调
    static private func executeScriptWithFile(_ fileName: String,
                                      funcName: String?,
                                      arguments: [String]?,
                                      completionHandler handler: NSUserAppleScriptTask.CompletionHandler?) {
        
        // 检查文件名是否为NSString类型且非空
        guard (fileName as AnyObject).isKind(of: NSString.self), !fileName.isEmpty else {
            print("【\(#function)】 文件名不正确:", fileName)
            return
        }
        
        //MARK: 使用 ProcessInfo 类的 environment 属性来获取进程的环境变量, 判断沙盒、非沙盒
        if let sandboxContainerID = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] {       // 沙盒
            // 如果 sandboxContainerID 不为 nil，表示应用在沙盒中
            print("应用处于沙盒中，沙盒容器ID为：\(sandboxContainerID)")
            
            // 获取应用程序脚本目录的URL
            let scriptDirUrl = getScriptLocalURL()
            
            // 构建脚本文件的URL，将文件名附加到脚本目录的URL后面
            let scriptUrl = scriptDirUrl?.appendingPathComponent(fileName)
            
            if let scriptUrl = scriptUrl, FileManager.default.fileExists(atPath: scriptUrl.path) {
                // 脚本文件存在，执行脚本
                do {
                    // 创建用户AppleScript任务
                    let task = try NSUserAppleScriptTask(url: scriptUrl)
                    
                    var descriptor: NSAppleEventDescriptor?
                    if let funcName = funcName {
                        // 创建用于脚本执行的事件描述符
                        descriptor = createEventDescriptor(with: funcName, arguments: arguments ?? [])
                    }
                    
                    // 执行脚本任务
                    task.execute(withAppleEvent: descriptor) { result, error in
                        if let handler = handler {
                            DispatchQueue.main.async {
                                // 执行完成后调用处理程序
                                handler(result, error)
                            }
                        }
                    }
                } catch {
                    print("【\(#function)】 创建用户AppleScript任务时出错:", error)
                }
            }
            
        } else {        // 非沙盒
            // 如果 sandboxContainerID 为 nil，表示应用不在沙盒中
            print("应用未处于沙盒中")
            // 执行 App 包内的 AppleScript 脚本文件
            executeAppleScriptInAppBundle(fileName, funcName: funcName, arguments: arguments, handler: handler)
        }
    }

    
    
    /// 创建一个用于生成Apple事件描述符的静态函数, 接受函数名称和参数列表作为输入
    /// - Parameters:
    ///   - funcName: 要执行的AppleScript函数的名称
    ///   - arguments: 传递给函数的参数列表
    /// - Returns: 返回一个NSAppleEventDescriptor对象，表示Apple事件描述符，或者返回nil（如果输入无效）
    static func createEventDescriptor(with funcName: String, arguments: [String]) -> NSAppleEventDescriptor? {
        // 检查函数名称是否为NSString类型且非空
        guard (funcName as AnyObject).isKind(of: NSString.self), !funcName.isEmpty else {
            return nil
        }
        
        /// 用于存储目标的Apple事件描述符
        var target: NSAppleEventDescriptor?

        /// 用于存储函数的Apple事件描述符，表示要在目标进程中执行的AppleScript函数的名称
        var function: NSAppleEventDescriptor?

        /// 用于存储参数的Apple事件描述符，表示传递给函数的参数列表
        var parameters: NSAppleEventDescriptor?
        
        // target
        
        // 创建目标描述符，表示当前进程
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        
        let size = MemoryLayout<ProcessSerialNumber>.size
        
        // 用进程序列号创建目标描述符
        target = NSAppleEventDescriptor(descriptorType: typeProcessSerialNumber, bytes: &psn, length: size)
        
        // function
        
        // 创建函数描述符，表示要执行的AppleScript函数名称
        function = NSAppleEventDescriptor(string: funcName)
        
        // parameters
        
        // 创建参数描述符，表示传递给函数的参数列表
        if !arguments.isEmpty {
            // 创建参数描述符列表
            parameters = NSAppleEventDescriptor.list()
            for (index, argument) in arguments.enumerated() {
                let param = NSAppleEventDescriptor(string: argument)
                // 将参数逐个插入参数描述符列表
                parameters?.insert(param, at: index + 1)
            }
        }
        
        // 创建最终的事件描述符，表示要执行的Apple事件
        let event = NSAppleEventDescriptor(eventClass: AEEventClass(kASAppleScriptSuite), eventID: AEEventID(kASSubroutineEvent), targetDescriptor: target, returnID: AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
        
        // 将函数描述符设置为子例程名称参数
        if let function = function {
            event.setParam(function, forKeyword: AEKeyword(keyASSubroutineName))
        }
        
        // 如果有参数，将参数描述符设置为直接对象参数
        if let parameters = parameters {
            event.setParam(parameters, forKeyword: keyDirectObject)
        }
        
        // 返回创建的事件描述符
        return event
    }
    
    
    /// 安装`指定的脚本文件`《单个文件》
    /// - Parameters:
    ///   - fileName: 要安装的脚本文件的名称
    ///   - handler: 安装完成后的处理程序，返回一个布尔值，指示安装是否成功
    static func installScriptWithFile(fileName: String, completionHandler handler: ((Bool) -> Void)?) {
        // 检查文件名是否为NSString类型且非空
        guard (fileName as AnyObject).isKind(of: NSString.self), !fileName.isEmpty else {
            print("【\(#function)】 文件名不正确:", fileName)
            handler?(false) // 调用处理程序并指示安装失败
            return
        }
        
        // 调用辅助函数 installScriptsWithArr 来安装单个文件
        installScriptsWithArr([fileName], completionHandler: handler)
    }
    
    /// 执行简单的脚本文件，如果本地不存在，从项目内copy到本地再执行
    /// 适用于一个脚本文件就是一条脚本指令，文件名就是脚本名称
    /// - Parameter fileName: 文件名
    static func executeScriptWithFile(_ fileName: String) {
        executeScriptWithFile(fileName, completionHandler: nil)
    }
    
    /// 执行简单的脚本文件，如果本地不存在，从项目内copy到本地再执行
    /// 适用于一个脚本文件就是一条脚本指令，文件名就是脚本名称
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - handler: 执行结果回调
    static func executeScriptWithFile(_ fileName: String, completionHandler handler: NSUserAppleScriptTask.CompletionHandler?) {
        executeScriptWithFile(fileName, funcName: nil, arguments: nil, completionHandler: handler)
    }
    
    
 
}




//MARK: - 测试通过的 弹窗安装AppleScript 脚本
extension LCAppleScriptManager {
    
    ///  安装`多个脚本`到`APP脚本库` 《 单独的 alert 弹窗 》
    /// - Parameters:
    ///   - fileNameArr: 脚本文件名数组
    ///   - handler: 结果回调
    public static func installScriptsWithArr(_ fileNameArr: [String], completionHandler handler: ((Bool) -> Void)?) {
        
        // 每次安装之前，记录没有弹窗过
        LCAppleScriptManager.shared.isAlertShowing = false
        
        if fileNameArr.isEmpty {
            NSLog("\(#function) file name array is 0 count")
            handler!(false)
            return
        }
        
        // 检查是否已经有弹窗在显示
        if LCAppleScriptManager.shared.isAlertShowing {
            print("弹窗已经在显示，不创建新的弹窗")
            return
        }
        
        
        let alert = NSAlert()
        alert.messageText = alertMessages
        alert.informativeText = alertInfomative
        alert.addButton(withTitle: alertInstall)
        alert.addButton(withTitle: alertCancel)
        
        // 记录已经弹窗过
        LCAppleScriptManager.shared.isAlertShowing = true
        
        // 运行模态
        let returnCode = alert.runModal()
        if returnCode == .alertFirstButtonReturn {  // 用户点击了安装按钮
            beginInstallScripts(fileNameArr: fileNameArr, completionHandler: handler!)
        }else {
            print("点击了cancel按钮")
            handler?(false)    // 回调false
            // 点击取消，记录没有弹窗显示过，下载会继续弹窗
            LCAppleScriptManager.shared.isAlertShowing = false
        }
    }
    
    
    
    /// 开始安装脚本
    /// - Parameters:
    ///   - fileNameArr: 脚本文件名数组
    ///   - handler: 结果回调
    static private func beginInstallScripts(fileNameArr: [String], completionHandler handler: @escaping (Bool) -> Void) {
        let scriptDirUrl = getScriptLocalURL()
        
        // 提示用户选择要打开的文件的面板。
        let openPanel = NSOpenPanel()
        openPanel.directoryURL = scriptDirUrl
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.prompt = panelPrompt
        openPanel.message = panelMessage
        
        openPanel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                // 用户点击了安装按钮
                guard let selectUrl = openPanel.url else {
                    handler(false)
                    return
                }
                
                if selectUrl == scriptDirUrl {
                    // 选择了正确的文件夹
                    var flag = true
                    for fileName in fileNameArr {
                        let destinationUrl = selectUrl.appendingPathComponent(fileName)
                        guard let sourceUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else {
                            print("\(#function) \(fileName) is not exist")
                            flag = false
                            continue
                        }
                        
                        do {
                            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                                // 文件存在，移除
                                try FileManager.default.removeItem(at: destinationUrl)
                            }
                            // 复制成功
                            try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
                            print("【\(#function)】 copy item to local success: \(fileName)")
                        } catch {
                            print("\(#function) copy item to local fail: \(error)")
                            flag = false
                        }
                    }
                    handler(flag)
                } else {
                    // 选的文件夹不是目标文件夹，重新选择
                    reinstallScripts(fileNameArr: fileNameArr, toCorrectURLWithCompletionHandler: handler)
                }
            } else {
                print("点击了cancel按钮")
                handler(false)
                
                // 点击取消，继续没有弹窗显示过
                LCAppleScriptManager.shared.isAlertShowing = false
            }
        }
    }
    
    
    
    /// 重新安装脚本
    ///
    /// - Parameters:
    ///   - fileNameArr: 待安装的文件名数组
    ///   - handler: 完成处理闭包，返回安装是否成功的布尔值
    static private func reinstallScripts(fileNameArr: [String], toCorrectURLWithCompletionHandler handler: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = NSLocalizedString("Kind tips", comment: "")
        alert.informativeText = NSLocalizedString("Install error path", comment: "")
        alert.addButton(withTitle: NSLocalizedString("Reselect", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        
        /// 判断用户, 是否选择 重新安装脚本 或 取消操作
        let returnCode = alert.runModal()
        if returnCode == .alertFirstButtonReturn {
            beginInstallScripts(fileNameArr: fileNameArr, completionHandler: handler)
        }
    }
    
}

