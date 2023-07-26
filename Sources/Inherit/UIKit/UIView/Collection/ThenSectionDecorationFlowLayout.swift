//
//  ThenSectionDecorationFlowLayout.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/21.
//

import UIKit

public final class ThenSectionDecorationFlowLayout: UICollectionViewFlowLayout {
    
    public weak var delegate: ThenSectionDecorationDelegate?
    
    var layoutAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    
    public override init() {
        super.init()
        
        self.scrollDirection = .vertical
        
        self.register(ThenSectionDecorationView.self, forDecorationViewOfKind: ThenSectionDecorationView.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView, let delegate = self.delegate else {
            return
        }
        
        if !layoutAttributes.isEmpty {
            layoutAttributes = [:]
        }
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            guard numberOfItems > 0,
                  let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                  let lastsItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section))
            else {
                continue
            }
            let headerSize      = delegate.collectionView(collectionView, layout: self, headerForSectionAt: section)
            let footerSize      = delegate.collectionView(collectionView, layout: self, footerForSectionAt: section)
            let sectionInset    = self.sectionInset
            let collectionInset = collectionView.contentInset
            /// frame
            let margin = delegate.collectionView(collectionView, layout: self, marginForSectionAt: section)
            let x = margin.left
            var y = firstItem.frame.minY + margin.top
            let w = collectionView.frame.width - collectionInset.left - collectionInset.right - margin.left - margin.right
            var h = lastsItem.frame.maxY - firstItem.frame.minY - margin.top - margin.bottom
            
            let type = delegate.collectionView(collectionView, layout: self, decorationTypeForSectionAt: section)
            switch type {
            case .default:
                y -= (sectionInset.top + collectionInset.top + headerSize.height)
                h += (sectionInset.top + sectionInset.bottom + headerSize.height + footerSize.height)
            case .topCenter:
                y -= (sectionInset.top + collectionInset.top + headerSize.height)
                h += (sectionInset.top + headerSize.height)
            case .bottomCenter:
                h += (sectionInset.bottom + footerSize.height)
            default:
                break
            }
            
            let attrs = ThenSectionLayoutAttributes(forDecorationViewOfKind: ThenSectionDecorationView.identifier, with: IndexPath(item: 0, section: section))
            attrs.frame = CGRect(x: x, y: y, width: w, height: h)
            attrs.zIndex = -1 // the most lower level
            attrs.image = delegate.collectionView(collectionView, layout: self, backgroundImageForSectionAt: section)
            attrs.cornerRadius = delegate.collectionView(collectionView, layout: self, cornerRadiusForSectionAt: section)
            attrs.backgroundColor = delegate.collectionView(collectionView, layout: self, backgroundColorForSectionAt: section) ?? .clear
            layoutAttributes[section] = attrs
        }
        
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        if elementKind == ThenSectionDecorationView.identifier {
            return layoutAttributes[section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind,at: indexPath)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: layoutAttributes.values.filter {
            return rect.intersects($0.frame)
        })
        return attrs
    }
    
}
