//
//  UITableView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UITableView {
    
    @discardableResult
    func updateInset(top: CGFloat? = nil,
                     left: CGFloat? = nil,
                     bottom: CGFloat? = nil,
                     right: CGFloat? = nil) -> ThenExtension {
        
        base.contentInset = UIEdgeInsets(top: top ?? base.contentInset.top,
                                         left: left ?? base.contentInset.left,
                                         bottom: bottom ?? base.contentInset.bottom,
                                         right: right ?? base.contentInset.right)
        return self
    }
    
    @discardableResult
    func separatorInset(_ closure: (inout UIEdgeInsets) -> Void) -> ThenExtension {
        var inset = base.separatorInset
        closure(&inset)
        base.separatorInset = inset
        return self
    }
    
    func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        guard let paths = base.indexPathsForVisibleRows, let path = indexPath, paths.contains(path) else { return }
        base.selectRow(at: path, animated: animated, scrollPosition: scrollPosition)
    }
    
    func deselectRow(at indexPath: IndexPath, animated: Bool) {
        guard let paths = base.indexPathsForVisibleRows, paths.contains(indexPath) else { return }
        base.deselectRow(at: indexPath, animated: animated)
    }
    
}

public extension ThenExtension where T: UITableView {
    
    //MARK: - Cell
    @discardableResult
    func registerNibWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> ThenExtension {
        let name = String(describing: cell)
        base.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> ThenExtension {
        base.register(cell, forCellReuseIdentifier: String(describing: cell))
        return self
    }
    
    func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> CellType {
        return base.dequeueReusableCell(withIdentifier: String(describing: cell)) as! CellType
    }
    
    func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type, for indexPath: IndexPath) -> CellType {
        return base.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as! CellType
    }
    
    //MARK: - HeaderFooterView
    @discardableResult
    func registerNibWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> ThenExtension {
        let name = String(describing: headerFooterView)
        base.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> ThenExtension {
        base.register(headerFooterView, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterView))
        return self
    }
    
    func dequeueHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> CellType {
        return base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerFooterView)) as! CellType
    }
}

