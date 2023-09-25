//
//  UIGestureRecognizer++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/14.
//

import ThenFoundation
import UIKit

private enum UIGestureAssociation {
    @UniqueAddress static var target
}

public extension ThenExtension where T: UIGestureRecognizer {
    @inlinable
    @discardableResult
    static func gesture(_ closure: @escaping (UIGestureRecognizer) -> Void) -> ThenExtension {
        return T().then.on(closure)
    }

    @discardableResult
    func on(_ closure: @escaping (UIGestureRecognizer) -> Void) -> ThenExtension {
        value.isEnabled = true
        var temp: [ObserverGestureTarget] = value.kit_gestureTargets ?? []
        let target = ObserverGestureTarget(gesture: value) { closure($0) }
        temp.append(target)
        value.kit_gestureTargets = temp
        return self
    }

    @discardableResult
    func off() -> ThenExtension {
        value.isEnabled = false
        value.kit_gestureTargets?.forEach { $0.dispose() }
        value.kit_gestureTargets?.removeAll()
        return self
    }
}

private extension NSObject {
    var kit_gestureTargets: [ObserverGestureTarget]? {
        get { then.binded(for: UIGestureAssociation.target) }
        set { then.bind(object: newValue, for: UIGestureAssociation.target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private final class ObserverGestureTarget: NSObject {
    weak var gesture: UIGestureRecognizer?
    let selector: Selector = #selector(ObserverGestureTarget.eventHandler(_:))
    var callback: ((UIGestureRecognizer) -> Void)?

    fileprivate init(gesture: UIGestureRecognizer, callback: ((UIGestureRecognizer) -> Void)?) {
        self.gesture = gesture
        self.callback = callback
        super.init()
        gesture.addTarget(self, action: selector)
    }

    @objc
    private func eventHandler(_ gesture: UIGestureRecognizer) {
        callback?(gesture)
    }

    fileprivate func dispose() {
        gesture?.removeTarget(self, action: selector)
        callback = nil
    }
}
