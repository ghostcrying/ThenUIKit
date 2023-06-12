//
//  UILabel+Shadow.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UILabel {
    
    /// shadow
    @discardableResult
    func applyShadow(color: UIColor = UIColor(hex: 0x000000).withAlphaComponent(0.25)) -> ThenExtension {
        value.applyShadow(color: color)
        return self
    }
    
}

public extension UILabel {
    
    func applyShadow(color: UIColor = UIColor(hex: 0x000000).withAlphaComponent(0.25)) {
        
        layerShadowColor = color
        layerShadowOpacity = 1
        layerShadowOffset = CGSize(width: 1, height: 1)
    }
}

