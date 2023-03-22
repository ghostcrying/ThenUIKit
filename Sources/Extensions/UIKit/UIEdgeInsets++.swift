//
//  UIEdgeInsets++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

extension UIEdgeInsets: ThenExtensionCompatible { }

public extension UIEdgeInsets {
    
    init(_ value: CGFloat) {
        self = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    init(t: CGFloat = 0, l: CGFloat = 0, b: CGFloat = 0, r: CGFloat = 0) {
        self = UIEdgeInsets(top: t, left: l, bottom: b, right: r)
    }
    
    init(_ elements: [CGFloat]) {
        self = UIEdgeInsets(top: elements[safe: 0] ?? 0,
                            left: elements[safe: 1] ?? 0,
                            bottom: elements[safe: 2] ?? 0,
                            right: elements[safe: 3] ?? 0)
    }
}


extension UIEdgeInsets {
    
    public static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }
    
    public static func - (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top - rhs.top,
                            left: lhs.left - rhs.left,
                            bottom: lhs.bottom - rhs.bottom,
                            right: lhs.right - rhs.right)
    }
    
    public static func * (_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top * rhs,
                            left: lhs.left * rhs,
                            bottom: lhs.bottom * rhs,
                            right: lhs.right * rhs)
    }
}
