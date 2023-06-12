//
//  UIScrollView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIScrollView {
    
    var isHolding: Bool {
        return value.isTracking || value.isDragging || value.isDecelerating
    }
    
    var isStayTop: Bool {
        return value.contentOffset.y == -value.contentInset.top
    }
    
    var isStayBottom: Bool {
        return value.contentOffset.y == value.contentSize.height - value.bounds.height + value.contentInset.bottom
    }
    
    @discardableResult
    func contentInset(_ closure: (inout UIEdgeInsets) -> Void) -> ThenExtension {
        var inset = value.contentInset
        closure(&inset)
        value.contentInset = inset
        return self
    }
    
    @discardableResult
    func scrollToTop(offset: CGPoint = .zero, animated: Bool = false) -> ThenExtension {
        let realOffset = CGPoint(x: offset.x, y: value.contentOffset.y - value.contentInset.top + offset.y)
        value.setContentOffset(realOffset, animated: animated)
        return self
    }
    
    @discardableResult
    func scrollToBottom(offset: CGPoint = .zero, animated: Bool = false) -> ThenExtension {
        let realOffset = CGPoint(x: offset.x, y: value.contentSize.height - value.bounds.height + value.contentInset.bottom + offset.y)
        value.setContentOffset(realOffset, animated: animated)
        return self
    }
}
