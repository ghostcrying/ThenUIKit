//
//  UIButton+Shadow.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIButton {
    
    /// shadow
    @discardableResult
    func applyShadow(color: UIColor = UIColor(hex: 0x000000).withAlphaComponent(0.25)) -> ThenExtension {
        base.applyShadow(color: color)
        return self
    }

}

public extension UIButton {
    
    func applyShadow(color: UIColor = UIColor(hex: 0x000000).withAlphaComponent(0.25)) {
        titleLabel?.layerShadowColor = color
        titleLabel?.layerShadowOpacity = 1
        titleLabel?.layerShadowOffset = CGSize(width: 1, height: 1)
    }
}
