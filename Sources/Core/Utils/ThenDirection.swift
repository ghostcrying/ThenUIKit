//
//  ThenDirection.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/28.
//

import Foundation

/// Direction of the animation used in AnimationType.from.
public enum ThenDirection: Int, CaseIterable {

    case top
    case left
    case right
    case bottom
    
    /// Checks if the animation should go on the X or Y axis.
    public var isVertical: Bool {
        switch self {
        case .top, .bottom:
            return true
        default:
            return false
        }
    }

    /// Positive or negative value to determine the direction.
    var sign: CGFloat {
        switch self {
        case .top, .left:
            return -1
        case .right, .bottom:
            return 1
        }
    }

    /// Random direction.
    public static func random() -> ThenDirection {
        return allCases.randomElement() ?? .top
    }
    
}

