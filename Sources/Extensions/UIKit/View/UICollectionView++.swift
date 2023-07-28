//
//  UICollectionView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UICollectionView {
    
    //MARK: - Cell
    @discardableResult
    func registerNibWithCell<CellType: UICollectionViewCell>(_ cell: CellType.Type) -> ThenExtension {
        let name = String(describing: cell)
        value.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassWithCell<CellType: UICollectionViewCell>(_ cell: CellType.Type) -> ThenExtension {
        value.register(cell, forCellWithReuseIdentifier: String(describing: cell))
        return self
    }
    
    func dequeueCell<CellType: UICollectionViewCell>(_ cell: CellType.Type, for indexPath: IndexPath) -> CellType {
        return value.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as! CellType
    }
    
    //MARK: - HeaderView
    @discardableResult
    func registerNibHeader<CellType: UICollectionReusableView>(_ type: CellType.Type) -> ThenExtension {
        let name = String(describing: type)
        value.register(UINib(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassHeader<CellType: UICollectionReusableView>(_ type: CellType.Type) -> ThenExtension {
        value.register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type))
        return self
    }
    
    func dequeueHeader<CellType: UICollectionReusableView>(_ type: CellType.Type, for indexPath: IndexPath) -> CellType {
        return value.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type), for: indexPath) as! CellType
    }
    
    //MARK: - FooterView
    @discardableResult
    func registerNibFooter<CellType: UICollectionReusableView>(_ type: CellType.Type) -> ThenExtension {
        let name = String(describing: type)
        value.register(UINib(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name)
        return self
    }
    
    @discardableResult
    func registerClassFooter<CellType: UICollectionReusableView>(_ type: CellType.Type) -> ThenExtension {
        value.register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type))
        return self
    }
    
    func dequeueFooter<CellType: UICollectionReusableView>(_ type: CellType.Type, for indexPath: IndexPath) -> CellType {
        return value.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type), for: indexPath) as! CellType
    }
}

public extension ThenExtension where T: UICollectionView {
    /// VisibleCells in the order they are displayed on screen.
    var orderedVisibleCells: [UICollectionViewCell] {
        return value.orderedVisibleCells
    }

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UICollectionViewCells in the argument section.
    func visibleCells(in section: Int) -> [UICollectionViewCell] {
        return value.visibleCells(in: section)
    }
}
    
public extension UICollectionView {

    /// VisibleCells in the order they are displayed on screen.
    var orderedVisibleCells: [UICollectionViewCell] {
        return indexPathsForVisibleItems.sorted().compactMap { cellForItem(at: $0) }
    }

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UICollectionViewCells in the argument section.
    func visibleCells(in section: Int) -> [UICollectionViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
}

