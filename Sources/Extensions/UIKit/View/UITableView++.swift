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
        
        value.contentInset = UIEdgeInsets(top: top ?? value.contentInset.top,
                                         left: left ?? value.contentInset.left,
                                         bottom: bottom ?? value.contentInset.bottom,
                                         right: right ?? value.contentInset.right)
        return self
    }
    
    @discardableResult
    func separatorInset(_ closure: (inout UIEdgeInsets) -> ()) -> ThenExtension {
        var inset = value.separatorInset
        closure(&inset)
        value.separatorInset = inset
        return self
    }
    
    @discardableResult
    func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> ThenExtension {
        guard let paths = value.indexPathsForVisibleRows, let path = indexPath, paths.contains(path) else {
            return self
        }
        value.selectRow(at: path, animated: animated, scrollPosition: scrollPosition)
        return self
    }
    
    @discardableResult
    func deselectRow(at indexPath: IndexPath, animated: Bool) -> ThenExtension {
        guard let paths = value.indexPathsForVisibleRows, paths.contains(indexPath) else {
            return self
        }
        value.deselectRow(at: indexPath, animated: animated)
        return self
    }
    
    func visibleCells(in section: Int) -> [UITableViewCell] {
        return value.visibleCells(in: section)
    }
}

public extension ThenExtension where T: UITableView {
    
    //MARK: - Cell
    @discardableResult
    func registerNibWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> ThenExtension {
        let name = String(describing: cell)
        value.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> ThenExtension {
        value.register(cell, forCellReuseIdentifier: String(describing: cell))
        return self
    }
    
    func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> CellType {
        return value.dequeueReusableCell(withIdentifier: String(describing: cell)) as! CellType
    }
    
    func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type, for indexPath: IndexPath) -> CellType {
        return value.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as! CellType
    }
    
    //MARK: - HeaderFooterView
    @discardableResult
    func registerNibWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> ThenExtension {
        let name = String(describing: headerFooterView)
        value.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> ThenExtension {
        value.register(headerFooterView, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterView))
        return self
    }
    
    func dequeueHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> CellType {
        return value.dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerFooterView)) as! CellType
    }
    
}

// MARK: - Cells
public extension UITableView {

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UITableViewCell in the argument section.
    func visibleCells(in section: Int) -> [UITableViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
}
