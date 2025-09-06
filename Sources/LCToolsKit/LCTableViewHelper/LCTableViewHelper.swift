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
    
    
    /// `移动`表格中的`一行`到`新位置`，如果`旧索引`和`新索引不同`才执行`移动操作`
    ///
    /// - Parameters:
    ///   - tableView: 目标 `NSTableView`，需要移动行的表格视图
    ///   - oldIndex: 行的原始索引
    ///   - newIndex: 行的新索引位置
    public static func moveRowIfNeeded(_ tableView: NSTableView, oldIndex: Int, newIndex: Int) {
        // 检查索引有效性以及是否需要移动， 如果索引无效或者相同，将不会执行移动操作
        guard oldIndex != newIndex,
              oldIndex >= 0, oldIndex < tableView.numberOfRows,
              newIndex >= 0, newIndex <= tableView.numberOfRows else { return }
        
        // 开始批量更新，保证动画和布局一致
        tableView.beginUpdates()
        
        // 执行移动操作
        tableView.moveRow(at: oldIndex, to: newIndex)
        
        // 结束批量更新，刷新表格显示动画
        tableView.endUpdates()
    }
    
    
    
    /// 刷新表格中`指定行`的数据，不会刷新`整个表格`
    ///
    /// - Parameters:
    ///   - tableView: 目标 `NSTableView`，需要刷新行的表格视图
    ///   - index: 需要刷新的行索引
    ///
    /// - Note: 如果索引无效，将不会执行刷新操作
    /// - Important: 刷新会包含该行的所有列
    public static func reloadRow(_ tableView: NSTableView, at index: Int) {
        // 检查索引有效性
        guard index >= 0 && index < tableView.numberOfRows else { return }
        
        // 创建行索引集合
        let rowIndexSet = IndexSet(integer: index)
        // 创建列索引集合（刷新该行所有列）
        let columnIndexSet = IndexSet(integersIn: 0..<tableView.numberOfColumns)
        
        // 执行刷新
        tableView.reloadData(forRowIndexes: rowIndexSet,
                             columnIndexes: columnIndexSet)
    }
    
    
    
}
