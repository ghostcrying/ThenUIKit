//
//  ThenSectionLayoutAttributes.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/21.
//

import UIKit

final internal class ThenSectionLayoutAttributes: UICollectionViewLayoutAttributes {
    
    /// the corner radiu of the section view
    var cornerRadius: CGFloat?
    
    /// the image of the section view
    var image: UIImage?
    
    /// the color of the section view
    var backgroundColor = UIColor.white
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ThenSectionLayoutAttributes
        copy.image           = self.image
        copy.cornerRadius    = self.cornerRadius
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? ThenSectionLayoutAttributes else {
            return false
        }
        if self.image != obj.image {
            return false
        }
        if self.cornerRadius != obj.cornerRadius {
            return false
        }
        if !self.backgroundColor.isEqual(obj.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
    
}


