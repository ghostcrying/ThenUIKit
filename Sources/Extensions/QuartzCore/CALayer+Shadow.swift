//
//  CALayer+Shadow.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: CALayer {
    
    @discardableResult
    func shadowApply(color: UIColor = .black,
                       opacity: Float = 0.5,
                       offset: CGSize = .zero,
                       radius: CGFloat = 5,
                       maskToBounds: Bool = false,
                       shouldRasterize: Bool = true,
                       rasterizationScale: CGFloat = UIScreen.main.scale,
                       shadowPath: CGPath? = nil) -> ThenExtension {
        
        value.shadowColor     = color.cgColor
        value.shadowOpacity   = opacity
        value.shadowOffset    = offset
        value.shadowRadius    = radius
        value.masksToBounds   = maskToBounds
        value.shouldRasterize = shouldRasterize
        value.rasterizationScale = rasterizationScale
        if let `shadowPath` = shadowPath {
            value.shadowPath = shadowPath
        }
        return self
    }
    
    @discardableResult
    func shadowRemove() -> ThenExtension {
        value.shadowColor    = UIColor.clear.cgColor
        value.shadowOpacity  = 0.0
        value.shadowOffset   = .zero
        value.shadowRadius   = 0
        value.shadowPath     = nil
        return self
    }
    
}
