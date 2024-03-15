import Foundation


struct AppData {
    /// 是否允许选择文件夹
    static var canChooseDirectories: Bool = false
}

/// 应用沙盒文件kit
public class LCAppSandboxFileKit: NSObject {
    
    /// 创建一个单例对象，方便在整个应用中使用
    public static let standard = LCAppSandboxFileKit()
    
    /// 请求访问`指定路径` (一般用于 `/` 根目录)
    /// - Parameters:
    ///   - path: 需要访问的路径
    ///   - completion: 当访问路径完成时的回调，如果成功获取路径权限，则返回 true，否则返回 false
    public func requestAccessForPath(_ path: String, completion: @escaping (Bool) -> Void) {
        // 创建一个沙盒文件访问对象
        let fileAccess = LCAppSandboxFileAccess()
        
        // 尝试访问指定路径，并在成功时调用回调
        let result = fileAccess.accessFilePath(path, persistPermission: true) {
            // 成功获取权限，调用回调并传入 true
            completion(true)
        }
        
        // 如果尝试访问路径失败，则调用回调并传入 false
        if result == false {
            completion(false)
        }
    }
    
    
    
    /// 清除`指定路径`的`访问权限`
    /// - Parameters:
    ///   - path: 需要清除访问权限的路径   (一般用于 `/` 根目录)
    ///   - completion: 当清除访问权限完成时的回调，如果成功清除权限，则返回 true，否则返回 false
    public func clearAccessForPath(_ path: String, completion: @escaping () -> Void) {
        // 创建一个沙盒文件访问对象
        let fileAccess = LCAppSandboxFileAccess()
        
        // 创建一个文件URL
        let url = URL(fileURLWithPath: path)
        
        // 尝试取消指定路径的权限
        fileAccess.bookmarkPersistanceDelegate?.clearBookmarkData(for: url)
        
        // 现在我们假设 `clearBookmarkData(for:)` 方法总是成功的
        completion()
    }
    
    
    
}
