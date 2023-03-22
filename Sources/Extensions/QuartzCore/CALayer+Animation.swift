//
//  CALayer+Animation.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: CALayer {
    
    func popup(_ duration: TimeInterval) {
        let animate = CAKeyframeAnimation(keyPath: "transform")
        animate.values = [CATransform3DMakeScale(0.5, 0.5, 0.5),
                          CATransform3DMakeScale(1.1, 1.1, 1.0),
                          CATransform3DMakeScale(1.0, 1.0, 1.0)]
        animate.duration = duration
        base.add(animate, forKey:"popup")
    }
}

