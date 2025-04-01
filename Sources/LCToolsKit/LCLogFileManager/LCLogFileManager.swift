//
//  LCLogFileManager.swift
//
//  Created by DevLiuSir on 2023/3/20.
//


import Darwin
import Foundation

/// 日志级别枚举
public enum LogLevel: String {
    case debug = "DBG"   // 调试级别日志
    case info  = "INF"   // 信息级别日志
    case error = "ERR"   // 错误级别日志
}

/// 日志选项枚举
public enum LogOption: Int {
    case timestamp  // 是否包含时间戳
    case level      // 是否包含日志级别
    case file       // 是否包含文件名
    case line       // 是否包含行号
    
    /// 默认日志选项
    public static func new() -> [LogOption] {
        return [timestamp, file, line, level]
    }
}

/// 日志输出方式枚举
public enum LogWriter: Int {
    case stdout   // 标准输出
    case stderr   // 错误输出
    case file     // 文件输出
}

/// 文本输出流协议，定义不同日志输出类型
public protocol Writer: TextOutputStream {
    var type: LogWriter { get }
}

/// 日志文件管理器
public class LCLogFileManager {
    public static let shared = LCLogFileManager() // 单例模式
    
    private var writer: Writer = StderrOutputStream() // 默认使用标准错误输出
    private var category: String? = nil // 日志类别，可选
    
    /// 初始化日志管理器，默认使用标准输出
    public init(writer: LogWriter = .stdout) {
        self.setWriter(writer)
    }
    
    /// 复制当前日志对象，并可以设置新的类别
    public func copy(category: String? = nil) -> LCLogFileManager {
        let logger = LCLogFileManager()
        logger.writer = LCLogFileManager.shared.writer
        if let category = category {
            logger.category = category
        }
        return logger
    }
    
    /// 记录日志
    public func log(level: LogLevel, options: [LogOption] = LogOption.new(), message: String, file: String = #file, line: UInt = #line) {
        self.writer.write(self.prefix(level, options, file, line) + " " + message + "\n")
    }
    
    /// 设置日志输出方式
    public func setWriter(_ writer: LogWriter) {
        switch writer {
        case .stdout:
            self.writer = StdoutOutputStream()
        case .stderr:
            self.writer = StderrOutputStream()
        case .file:
            let fm = FileManager.default
            let fileURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
            
            if !fm.fileExists(atPath: fileURL.path) {
                try? "".data(using: .utf8)?.write(to: fileURL)
            }
            
            do {
                let handle = try FileHandle(forWritingTo: fileURL)
                handle.seekToEndOfFile()
                handle.write("----------------\n".data(using: .utf8)!)
                self.writer = FileHandlerOutputStream(handle)
            } catch let err {
                print("error to init file handler: \(err)")
                self.writer = StdoutOutputStream()
            }
        }
    }
    
    /// 删除日志文件（如果已超过指定的秒数）
    public static func deleteLogFile(afterSeconds seconds: Int) {
        let fm = FileManager.default
        let fileURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        
        guard fm.fileExists(atPath: fileURL.path) else {
            print("日志文件不存在")
            return
        }
        
        do {
            let attributes = try fm.attributesOfItem(atPath: fileURL.path)
            if let creationDate = attributes[.creationDate] as? Date {
                if Date().timeIntervalSince(creationDate) >= TimeInterval(seconds) {
                    try fm.removeItem(at: fileURL)
                    print("日志文件已删除，超过 \(seconds) 秒的保留期限")
                } else {
                    print("日志文件未达到 \(seconds) 秒的保留期限")
                }
            }
        } catch {
            print("删除日志文件时出错: \(error)")
        }
    }
    
    
    //MARK: 便捷写入日志方法
    
    public static func debug(_ message: String, log: LCLogFileManager = LCLogFileManager.shared, file: String = #file, line: UInt = #line) {
        log.log(level: .debug, message: message, file: file, line: line)
    }
    
    public static func info(_ message: String, log: LCLogFileManager = LCLogFileManager.shared, file: String = #file, line: UInt = #line) {
        log.log(level: .info, message: message, file: file, line: line)
    }
    
    public static func error(_ message: String, log: LCLogFileManager = LCLogFileManager.shared, file: String = #file, line: UInt = #line) {
        log.log(level: .error, message: message, file: file, line: line)
    }
    
    /// 生成日志前缀
    private func prefix(_ level: LogLevel, _ options: [LogOption], _ file: String = #file, _ line: UInt = #line) -> String {
        var prefix = ""
        
        if options.contains(.timestamp) {
            self.space(&prefix, LCLogFileManager.timestampFormatter.string(from: Date()))
        }
        
        if options.contains(.file) {
            if let f = file.split(separator: "/").last {
                self.space(&prefix, String(f))
            }
            if options.contains(.line) {
                prefix += ":\(line)"
            }
        } else if options.contains(.line) {
            self.space(&prefix, "\(line)")
        }
        
        if options.contains(.level) {
            self.space(&prefix, level.rawValue)
        }
        
        if let category = self.category {
            self.space(&prefix, "[\(category)]")
        }
        
        return prefix
    }
    
    /// 添加空格分隔日志信息
    private func space(_ origin: inout String, _ str: String) {
        if origin.last != " " && !origin.isEmpty {
            origin += " "
        }
        origin += str
    }
}

extension LCLogFileManager {
    
    // MARK: - 时间戳格式化器
    
    /// 时间戳格式化器
    /// 用于格式化日志中的时间戳，使其符合 "yyyy-MM-dd HH:mm:ss" 格式
    private static var timestampFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // 确保时间格式稳定
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 设定日期格式
        return formatter
    }
    
    // MARK: - 输出流
    
    // MARK: 标准输出流（stdout）
    
    /// 标准输出流（stdout）
    /// 适用于控制台日志打印，例如 `print()` 的输出
    private struct StdoutOutputStream: Writer {
        public let type: LogWriter = .stdout
        
        /// 将日志内容写入标准输出流
        mutating func write(_ string: String) {
            fputs(string, stdout) // 直接输出到标准输出（控制台）
        }
    }
    
    // MARK: 标准错误输出流（stderr）
    
    /// 标准错误输出流（stderr）
    /// 适用于打印错误信息，例如 `NSLog()` 或 `fatalError()` 的输出
    private struct StderrOutputStream: Writer {
        public let type: LogWriter = .stderr
        
        /// 将日志内容写入标准错误流
        mutating func write(_ string: String) {
            fputs(string, stderr) // 直接输出到标准错误流
        }
    }
    
    // MARK: 文件输出流（日志持久化）
    
    /// 文件输出流（日志持久化）
    /// 适用于将日志内容写入本地文件，便于日志存储和分析
    struct FileHandlerOutputStream: Writer {
        public let type: LogWriter = .file
        
        private let fileHandle: FileHandle // 文件句柄，用于写入数据
        private let encoding: String.Encoding // 字符编码，默认使用 UTF-8
        
        /// 初始化文件输出流
        /// - Parameters:
        ///   - fileHandle: 目标文件的 `FileHandle`
        ///   - encoding: 文本编码格式（默认 UTF-8）
        init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
            self.fileHandle = fileHandle
            self.encoding = encoding
        }
        
        /// 将日志内容写入指定的文件
        mutating func write(_ string: String) {
            if let data = string.data(using: encoding) {
                self.fileHandle.write(data) // 直接写入文件
            }
        }
    }
}

