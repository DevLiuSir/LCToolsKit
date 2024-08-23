//
//  LCTemperatureUtils.swift
//
//  Created by DevLiuSir on 2020/7/6.
//
//


import Foundation


/// 温度单位枚举
public enum TemperatureUnit {
    case celsius
    case fahrenheit
}


/// 温度工具类
public class LCTemperatureUtils {
    /*
     将`摄氏度`转换为`华氏度`：
     公式：(摄氏度 * 9/5) + 32
     用于在摄氏度（°C）和华氏度（°F）之间进行转换。这两个温标之间存在线性关系。
     
     将`华氏度`转换为`摄氏度`：
     公式：(华氏度 - 32) * 5/9
     用于在华氏度（°F）和摄氏度（°C）之间进行转换。这两个温标之间也是线性关系。
     */
    
    
    /// 将`摄氏度`转换为`华氏度`
    /// - Parameter celsius: 摄氏度温度
    /// - Returns: 华氏度温度
    public static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
    /// 将`华氏度`转换为`摄氏度`
    /// - Parameter fahrenheit: 华氏度温度
    /// - Returns: 摄氏度温度
    public static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
}
