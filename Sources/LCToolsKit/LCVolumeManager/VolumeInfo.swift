//
//  VolumeInfo.swift
//  LCVolumeManager
//
//  Created by DevLiuSir on 2020/3/11.
//

import Cocoa

/// 卷信息
public struct VolumeInfo {
    /// 卷名称
    public let name: String
    /// 卷类型: 磁盘的格式：Mac OS扩展（日志式）、APFS........
    public let volumeType: String
    /// 卷的图标
    public let image: NSImage?
    /// 卷的容量
    public let capacity: Int64
    /// 卷的可用容量
    public let available: Int64
    /// 是否为可移动磁盘
    public let removable: Bool
    /// 是否可弹出
    public let isEjectable: Bool
    /// 是否是内部
    public let isInternal: Bool
}
