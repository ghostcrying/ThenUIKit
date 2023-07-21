//
//  CALayer+Animation.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: CALayer {
    
    @discardableResult
    func popup(_ duration: TimeInterval) -> ThenExtension {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [
            CATransform3DMakeScale(0.5, 0.5, 0.5),
            CATransform3DMakeScale(1.1, 1.1, 1.0),
            CATransform3DMakeScale(1.0, 1.0, 1.0)
        ]
        animation.duration = duration
        value.add(animation, forKey: "popup")
        return self
    }
}

