//
//  CALayer+Gradient.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import ThenFoundation
import UIKit

public extension ThenExtension where T: CALayer {
    @discardableResult
    func gradientApply(
        frame: CGRect,
        start: CGPoint,
        end: CGPoint,
        colors: [UIColor]
    ) -> ThenExtension {
        let gradient = value.gradientLayer ?? CAGradientLayer()
        gradient.frame = frame
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.colors = colors.compactMap { $0.cgColor }
        if gradient.superlayer == nil {
            value.insertSublayer(gradient, at: 0)
        }
        value.gradientLayer = gradient
        return self
    }

    @discardableResult
    func gradientRemove() -> ThenExtension {
        value.gradientLayer?.removeFromSuperlayer()
        value.gradientLayer = nil
        return self
    }

    var gradientLayer: CAGradientLayer? {
        get { value.gradientLayer }
        set { value.gradientLayer = newValue }
    }
}

private extension CALayer {
    var gradientLayer: CAGradientLayer? {
        get { then.binded(for: CALayerBindKey.gradient) }
        set { then.bind(object: newValue, for: CALayerBindKey.gradient, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private enum CALayerBindKey {
    @UniqueAddress static var gradient
}
