//
//
//  LCDateManager.swift
//
//  Created by DevLiuSir on 2021/6/24.
//


import Foundation



public enum Weekday: String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    func text(type: Int = 0) -> String {
        var text = ""
        switch self {
        case .monday:       text = type == 0 ? "周一" : "星期一"
        case .tuesday:      text = type == 0 ? "周二" : "星期二"
        case .wednesday:    text = type == 0 ? "周三" : "星期三"
        case .thursday:     text = type == 0 ? "周四" : "星期四"
        case .friday:       text = type == 0 ? "周五" : "星期五"
        case .saturday:     text = type == 0 ? "周六" : "星期六"
        case .sunday:       text = type == 0 ? "周日" : "星期日"
        }
        return text
    }
}

/// 时间管理器
public class LCDateManager {
    
    
    // MARK: - public static Formatters
    
    /// 工作日格式化程序
    public static let weekDayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh-Hans")
        return df
    }()
    
    /// 年月日格式日期
    public static let yearMonthDayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        //df.calendar = Calendar(identifier: .chinese) // 农历
        return df
    }()
    
    /// 带有“年月日”格式的日期：yyyy年MM月dd日
    public static let chineseYearMonthDayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy年MM月dd日"
        return df
    }()
    
    /// 仅显示“yyyy年”格式的日期：yyyy年
    public static let chineseYearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy年"
        return df
    }()
    
    
    /// 年月日格式日期，使用 "/" 分割
    ///
    /// 示例：2024/08/29
    public static let yearMonthDayFormatterWithSlash: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        // df.calendar = Calendar(identifier: .chinese) // 可选：设置为农历日历
        return df
    }()
    
    
    /// 年月日格式日期，使用 "." 分割
    ///
    /// 示例：2024.08.29
    public static let yearMonthDayFormatterWithDot: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        // df.calendar = Calendar(identifier: .chinese) // 可选：设置为农历日历
        return df
    }()
    
    
    /// 仅显示“MM月dd日”格式的日期：MM月dd日
    public static let chineseMonthDayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM月dd日"
        return df
    }()
    
    /// 时间格式（带秒）
    public static let timeFormatterWithSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    /// 时间格式（不带秒）
    public static let timeFormatterNoSeconds: DateFormatter = {
        let formatter = DateFormatter()
        // 设置时间格式，例如 "HH:mm:ss" 表示小时:分钟:秒
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    
    /// 小时格式
    public static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 设置时间格式，例如 "HH" 表示小时
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    /// 分钟格式
    public static let minuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 设置时间格式，例如 "mm" 表示分钟
        formatter.dateFormat = "mm"
        return formatter
    }()
    
    /// 秒格式
    public static let secondFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 设置时间格式，例如 "ss" 表示秒
        formatter.dateFormat = "ss"
        return formatter
    }()
    
    /// 将可选的 `Date` 转换为 `yyyy-MM-dd` 格式的字符串
    /// - Parameter date: 需要转换的 `Date` 对象
    /// - Returns: 返回格式化后的日期字符串（`yyyy-MM-dd`），如 `2025-03-01`，若 `date` 为空则返回空字符串
    public static func formatToDateString(from date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai") // 北京时间
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /// 根据日期格式和字符串，创建日期实例
    public static func date(from string: String, format: String, chinaTimeZone: Bool = false) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        if chinaTimeZone { formatter.timeZone = TimeZone(identifier: "Asia/Shanghai") }
        return formatter.date(from: string)
    }
    
    /// 根据时间戳返回格式化的日期字符串
    public static func dateString(from timeInterval: TimeInterval, format: String) -> String {
        return LCDateManager.formatToDateString(from: Date(timeIntervalSince1970: timeInterval))
    }
    
    /// 将 `Date` 转换成指定格式的字符串
    public static func string(from date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// 获取日期所在月的第一天
    public static func firstDayOfMonth(for date: Date) -> Date {
        return Calendar.current.dateInterval(of: .month, for: date)?.start ?? date
    }
    
    /// 获取日期所在月的最后一天
    public static func lastDayOfMonth(for date: Date) -> Date {
        if let end = Calendar.current.dateInterval(of: .month, for: date)?.end {
            return Calendar.current.date(byAdding: .day, value: -1, to: end) ?? date
        }
        return date
    }
    
    /// 获取当前月的第一天
    public static func firstDayOfCurrentMonth() -> Date {
        return firstDayOfMonth(for: Date())
    }
    
    /// 获取当前月的最后一天
    public static func lastDayOfCurrentMonth() -> Date {
        return lastDayOfMonth(for: Date())
    }
    
    /// 计算当前日期 + 指定天数后的日期
    public static func addDays(to date: Date, days count: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: count, to: date)!
    }
    
    /// 获取日期所在周的所有日期
    public static func daysForWholeWeek(of date: Date) -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let offset = calendar.firstWeekday == 1 ? weekday - 2 : weekday - 1
        let startOfWeek = calendar.date(byAdding: .day, value: -offset, to: date)!
        var weekDates: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                weekDates.append(day)
            }
        }
        return weekDates
    }
    
    /// 获取当前日期是本月的第几周
    public static func weekIndexOfMonth(for date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth!
    }
    
    /// 获取某一年有多少天
    public static func daysInYear(_ year: Int) -> Int {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let startOfNextYear = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
        return calendar.dateComponents([.day], from: startOfYear, to: startOfNextYear).day!
    }
    
    /// 获取某个月有多少天
    public static func dayCountOfMonth(for date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    /// 判断两个日期是否在同一年
    public static func isSameYear(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.component(.year, from: date1) == Calendar.current.component(.year, from: date2)
    }
    
    /// 判断两个日期是否在同一月
    public static func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return isSameYear(date1, date2) && calendar.component(.month, from: date1) == calendar.component(.month, from: date2)
    }
    
    /// 判断两个日期是否是同一天
    public static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return isSameMonth(date1, date2) && calendar.component(.day, from: date1) == calendar.component(.day, from: date2)
    }
    
    /// 获取日期的年、月、日、时、分、秒
    public static func dateComponents(for date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekOfYear, .weekOfMonth, .hour, .minute, .second], from: date)
    }
}

