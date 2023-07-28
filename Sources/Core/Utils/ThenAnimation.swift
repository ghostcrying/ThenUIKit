//
//  ThenAnimation.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/28.
//

import Foundation

/// ThenAnimation available to perform/
///
///  - vector: animate from x and y values
///  - scale:  zoom scale animate
///  - rotate: roate animate
public enum ThenAnimation: ThenAnimationType {

    case from(direction: ThenDirection, offset: CGFloat)
    case vector(CGVector)
    case scale(_ scale: CGFloat)
    case rotate(_ angle: CGFloat)
    case identity

    /// Creates the corresponding CGAffineTransform for AnimationType.from.
    public var initialTransform: CGAffineTransform {
        switch self {
        case .from(let direction, let offset):
            let sign = direction.sign
            if direction.isVertical {
                return CGAffineTransform(translationX: 0, y: offset * sign)
            }
            return CGAffineTransform(translationX: offset * sign, y: 0)
        case .vector(let vector):
            return CGAffineTransform(translationX: vector.dx, y: vector.dy)
        case .scale(let scale):
            return CGAffineTransform(scaleX: scale, y: scale)
        case .rotate(let angle):
            return CGAffineTransform(rotationAngle: angle)
        case .identity:
            return .identity
        }
    }

    /// Generates a random ThenAnimation.
    ///
    /// - Returns: Newly generated random ThenAnimation.
    public static func random() -> ThenAnimation {
        let index = Int.random(in: 0..<3)
        if index == 1 {
            return ThenAnimation.vector(CGVector(dx: .random(in: -10...10), dy: .random(in: -30...30)))
        } else if index == 2 {
            let scale = Double.random(in: 0...2)
            return ThenAnimation.scale(CGFloat(scale))
        }
        let angle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
        return ThenAnimation.rotate(angle)
    }

}

