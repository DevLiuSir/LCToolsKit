//
//  LCDiskVolumeManager.swift
//  LCDiskVolumeManager
//
//  Created by DevLiuSir on 2020/3/11.
//


import Cocoa

/// 卷宗管理员
public class LCDiskVolumeManager: NSObject {
    
    /// 单列
    public static let shared = LCDiskVolumeManager()
    
    /// 私有属性，用于格式化字节数
    private let bytesFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useTB] // 适当的单位
        formatter.countStyle = .file        // 文件大小的显示风格
        return formatter
    }()
    
    
    //MARK: - Private Methods
    
    /// 获取卷的信息，根据传入的URL
    /// - Parameter volumeURL: 磁盘的URL
    /// - Returns: VolumeInfo 结构体
    private func getVolumeInfo(_ volumeURL: URL) -> VolumeInfo? {
        
        var nameResource: AnyObject?, removableResource: AnyObject?, capacityResource: AnyObject?,
            availableSpaceResource: AnyObject?, localDiskResource: AnyObject?, volumeFormat: AnyObject?, isEjectable: AnyObject?, isInternal: AnyObject?
        do {
            try (volumeURL as NSURL).getResourceValue(&nameResource, forKey: URLResourceKey.volumeNameKey)
            try (volumeURL as NSURL).getResourceValue(&capacityResource, forKey: URLResourceKey.volumeTotalCapacityKey)
            try (volumeURL as NSURL).getResourceValue(&removableResource, forKey: URLResourceKey.volumeIsRemovableKey)
            try (volumeURL as NSURL).getResourceValue(&availableSpaceResource, forKey: URLResourceKey.volumeAvailableCapacityKey)
            try (volumeURL as NSURL).getResourceValue(&localDiskResource, forKey: URLResourceKey.volumeIsLocalKey)
            try (volumeURL as NSURL).getResourceValue(&volumeFormat, forKey: URLResourceKey.volumeLocalizedFormatDescriptionKey)
            try (volumeURL as NSURL).getResourceValue(&isEjectable, forKey: URLResourceKey.volumeIsEjectableKey)
            try (volumeURL as NSURL).getResourceValue(&isInternal, forKey: URLResourceKey.volumeIsInternalKey)
        } catch {
            return nil
        }
        
        guard let name = nameResource as? String,
              let capacity = capacityResource?.int64Value as Int64?,
              let removable = removableResource as? Bool,
              let available = availableSpaceResource?.int64Value as Int64?,
              let volumeFormat = volumeFormat as? String,
              let Ejectable = isEjectable as? Bool,
              let Internal = isInternal as? Bool
        else {
            return nil
        }
        
        let image = NSWorkspace.shared.icon(forFile: volumeURL.path)
        let volumeInfo = VolumeInfo(name: name, volumeType: volumeFormat, image: image,
                                    capacity: capacity, available: available,
                                    removable: removable, isEjectable: Ejectable, isInternal: Internal)
        return volumeInfo
    }
    
    
    /// 已装载的卷
    /// - Returns: VolumeInfo 数组
    private func mountedVolumes() -> [VolumeInfo] {
        let keysToRead = [
            URLResourceKey.volumeIsRemovableKey,
            URLResourceKey.volumeLocalizedNameKey,
            URLResourceKey.volumeIsLocalKey,
            URLResourceKey.volumeTotalCapacityKey,
            URLResourceKey.volumeUUIDStringKey,
            URLResourceKey.volumeAvailableCapacityKey,
            URLResourceKey.volumeLocalizedFormatDescriptionKey,  // 卷的格式名称
            URLResourceKey.volumeIsEjectableKey,    //用于确定卷是否可在软件控制下从驱动器机制弹出的键，以布尔NSNumber对象（只读）的形式返回
            URLResourceKey.volumeIsInternalKey  //用于确定卷是否连接到内部总线的键，作为布尔NSNumber对象返回，如果无法确定，则返回nil（只读）。
        ]
        guard let volumes = FileManager.default
            .mountedVolumeURLs(includingResourceValuesForKeys: keysToRead,
                               options: [.skipHiddenVolumes]) else {
            return []
        }
        // 磁盘信息数组
        var volumesInfo = [VolumeInfo]()
        
        // 遍历所有外置磁盘，传入URL，获取到卷信息，然后添加到 VolumeInfo 结构体
        for volumeURL in volumes {
            if let info = LCDiskVolumeManager.shared.getVolumeInfo(volumeURL) {
                volumesInfo.append(info)
            }
        }
        return volumesInfo
    }
    
    
    //MARK: - Public Methods
    
    /// 格式化给定的字节计数值
    /// - Parameter bytes: 需要格式化的字节数
    /// - Returns: 格式化后的字符串
    public func string(fromByteCount bytes: Int64) -> String {
        return bytesFormatter.string(fromByteCount: bytes)
    }
    
    /// 获取所有`可移动外置磁盘`
    /// - Returns: 可移动外置磁盘的 VolumeInfo 数组
    public func getRemovableVolumes() -> [VolumeInfo] {
        let mountedVolumes = LCDiskVolumeManager.shared.mountedVolumes()
        let volumes = mountedVolumes.filter { $0.removable }
        return volumes
    }
    
    /// 获取所有`内置磁盘`
    /// - Returns: 内置磁盘的 VolumeInfo 数组
    public func getInternalVolumes() -> [VolumeInfo] {
        let mountedVolumes = LCDiskVolumeManager.shared.mountedVolumes()
        let volumes = mountedVolumes.filter { !$0.removable }
        return volumes
    }
    
}
