//
//  UIView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIView {
        
    func debugBorder() {
        if value.layer.borderWidth > 0 {
            return
        }
        
        let rc = UIColor(hex: Int.random(in: (0...0xffffff)))
        value.layer.borderColor = rc.cgColor
        value.layer.borderWidth = 1
        value.subviews.forEach { $0.then.debugBorder() }
    }
}

public extension ThenExtension where T: UIView {
    
    var top: CGFloat {
        get { return value.frame.minY }
        set {
            var frame = value.frame
            frame.origin.y = newValue
            value.frame = frame
        }
    }
    
    var left: CGFloat {
        get { return value.frame.minX }
        set {
            var frame = value.frame
            frame.origin.x = newValue
            value.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get { return value.frame.maxY }
        set {
            var frame = value.frame
            frame.origin.y = newValue - frame.height
            value.frame = frame
        }
    }
    
    var right: CGFloat {
        get { return value.frame.maxX }
        set {
            var frame = value.frame
            frame.origin.x = newValue - frame.width
            value.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get { return value.frame.midX }
        set {
            var frame = value.frame
            frame.origin.x = newValue - frame.width / 2.0
            value.frame = frame
        }
    }
    
    var centerY: CGFloat {
        get { return value.frame.midY }
        set {
            var frame = value.frame
            frame.origin.y = newValue - frame.height / 2.0
            value.frame = frame
        }
    }
    
    var origin: CGPoint {
        get { return value.frame.origin }
        set {
            var frame = value.frame
            frame.origin = newValue
            value.frame = frame
        }
    }
    
    var center: CGPoint {
        get { return value.center}
        set { value.center = newValue }
    }
    
    var size: CGSize {
        get { return value.frame.size }
        set {
            var frame = value.frame
            frame.size = newValue
            value.frame = frame
        }
    }
    
    var width: CGFloat {
        get { return value.frame.width }
        set {
            var frame = value.frame
            frame.size.width = newValue
            value.frame = frame
        }
    }
    
    var height: CGFloat {
        get { return value.frame.height }
        set {
            var frame = value.frame
            frame.size.height = newValue
            value.frame = frame
        }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return value.safeAreaInsets
        } else {
            return .zero
        }
    }
}

public extension ThenExtension where T: UIView {
    
    func layout(_ closure: (_ maker: ThenViewLayoutMaker) -> ()) {
        let m = ThenViewLayoutMaker(rect: value.frame)
        closure(m)
        value.frame = m.frame
    }
}

public class ThenViewLayoutMaker {
    
    public var frame: CGRect = .zero
    
    public init(rect: CGRect) {
        self.frame = rect
    }
}

public extension ThenViewLayoutMaker {
    
    var top: CGFloat {
        get { return frame.minY }
        set { frame.origin.y = newValue }
    }
    
    var left: CGFloat {
        get { return frame.minX }
        set { frame.origin.x = newValue }
    }
    
    var bottom: CGFloat {
        get { return frame.maxY }
        set { frame.origin.y = newValue - frame.height }
    }
    
    var right: CGFloat {
        get { return frame.maxX }
        set { frame.origin.x = newValue - frame.width }
    }
    
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    
    var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }
    
    var width: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }
    
    var center: CGPoint {
        get { return CGPoint(x: frame.midX, y: frame.midY) }
        set { frame.origin = CGPoint(x: newValue.x - frame.width / 2, y: newValue.y - frame.height / 2) }
    }
    
    var centerX: CGFloat {
        get { return frame.midX }
        set { frame.origin.x = newValue - frame.width / 2 }
    }
    
    var centerY: CGFloat {
        get { return frame.midY }
        set { frame.origin.y = newValue - frame.height / 2 }
    }
}
