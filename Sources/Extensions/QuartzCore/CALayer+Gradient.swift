//
//  CALayer+Gradient.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: CALayer {
    
    @discardableResult
    func gradientApply(frame: CGRect, start: CGPoint, end: CGPoint, colors: [UIColor]) -> ThenExtension {
        let gradient = base.gradientLayer ?? CAGradientLayer()
        gradient.frame = frame
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.colors = colors.compactMap { $0.cgColor }
        if gradient.superlayer == nil {
            base.insertSublayer(gradient, at: 0)
        }
        base.gradientLayer = gradient
        return self
    }
    
    @discardableResult
    func gradientRemove() -> ThenExtension {
        base.gradientLayer?.removeFromSuperlayer()
        base.gradientLayer = nil
        return self
    }
    
    var gradientLayer: CAGradientLayer? {
        get { return base.gradientLayer }
        set { base.gradientLayer = newValue }
    }
    
}

fileprivate extension CALayer {
    
    private static var gradientLayerBindKey: String = "com.then.layer.gradient.bind.key"
    var gradientLayer: CAGradientLayer? {
        get { return then.binded(for: &CALayer.gradientLayerBindKey) }
        set { then.bind(object: newValue, for: &CALayer.gradientLayerBindKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
