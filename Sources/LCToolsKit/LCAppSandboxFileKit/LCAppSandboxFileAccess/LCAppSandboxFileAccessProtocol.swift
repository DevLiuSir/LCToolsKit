//
//  LCAppSandboxFileAccessProtocol.swift
//  IPSWLibrary
//
//  Created by Liu Chuan on 2019/12/20.
//


import Cocoa


// 定义一个协议，规定了处理文件访问权限的一些基本方法
protocol LCAppSandboxFileAccessProtocol: AnyObject {
    
    /// 获取给定URL的书签数据
    ///
    /// - Parameter url: 要获取书签数据的URL
    /// - Returns: 书签数据，如果获取失败则为nil
    func bookmarkData(for url: URL) -> Data?
    
    /// 为指定的URL设置书签数据
    ///
    /// - Parameters:
    ///   - data: 要设置的书签数据
    ///   - url: 要设置书签数据的URL
    func setBookmarkData(_ data: Data, for url: URL)
    
    /// 清除指定URL的书签数据
    ///
    /// - Parameter url: 要清除书签数据的URL
    func clearBookmarkData(for url: URL)
}
