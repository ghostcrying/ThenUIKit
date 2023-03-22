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
        
        base.shadowColor     = color.cgColor
        base.shadowOpacity   = opacity
        base.shadowOffset    = offset
        base.shadowRadius    = radius
        base.masksToBounds   = maskToBounds
        base.shouldRasterize = shouldRasterize
        base.rasterizationScale = rasterizationScale
        if let `shadowPath` = shadowPath {
            base.shadowPath = shadowPath
        }
        return self
    }
    
    @discardableResult
    func shadowRemove() -> ThenExtension {
        base.shadowColor    = UIColor.clear.cgColor
        base.shadowOpacity  = 0.0
        base.shadowOffset   = .zero
        base.shadowRadius   = 0
        base.shadowPath     = nil
        return self
    }
    
}
