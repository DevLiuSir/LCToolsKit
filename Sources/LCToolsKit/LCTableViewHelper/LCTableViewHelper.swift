//
//  LCTableViewHelper.swift
//
//
//  Created by DevLiuSir on 2019/3/2.
//



import Cocoa

/// 表格视图助手类，包含了一些用于处理表格视图的实用方法
public class LCTableViewHelper {
    
    /// 获取`视图`在`表格视图`中`对应的行号`
    ///
    /// - Parameters:
    ///   - view: 要查找行号的视图
    ///   - tableView: 目标表格视图
    /// - Returns: 视图在表格视图中的行号，如果未找到则返回 -1
    public static func row(for view: NSView, in tableView: NSTableView) -> Int {
        // 将视图的原点坐标从视图坐标系转换为表格视图坐标系
        let viewOrigin = view.convert(NSPoint.zero, to: tableView)
        
        // 使用转换后的坐标查找在表格视图中的行号
        let row = tableView.row(at: viewOrigin)
        
        return row
    }
    
    
    
    /// `仅更新``新增`或`删除的行`
    ///
    /// - Parameters:
    ///   - tableView: 需要更新的表格视图
    ///   - index: 新增或删除行的索引
    ///   - isInsertion: 是否是插入操作（true 为插入，false 为删除）
    public static func updateTableViewRow(_ tableView: NSTableView, at index: Int, isInsertion: Bool) {
        DispatchQueue.main.async {
            tableView.beginUpdates()
            if isInsertion {
                tableView.insertRows(at: IndexSet(integer: index), withAnimation: .effectGap)
            } else {
                // 检查索引是否有效
                if index >= 0 && index < tableView.numberOfRows {
                    tableView.removeRows(at: IndexSet(integer: index), withAnimation: .effectFade)
                } else {
                    print("无效的删除索引：\(index)")
                }
            }
            tableView.endUpdates()
        }
    }
    
    
}
