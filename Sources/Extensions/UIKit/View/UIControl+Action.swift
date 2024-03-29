//
//  UIControl+Action.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import ThenFoundation
import UIKit

public extension ThenExtension where T: UIButton {
    /// 间隔delayInterval后才响应点击
    var delayInterval: TimeInterval {
        get { value.kit_delayInterval ?? 0 }
        set { value.kit_delayInterval = newValue }
    }
}

public extension ThenExtension where T: UIControl {
    @discardableResult
    func on(_ event: UIControl.Event = .touchUpInside, _ closure: @escaping @autoclosure () -> Void) -> ThenExtension {
        var temp: [ControlTarget] = value.kit_controlTargets ?? []
        let target = ControlTarget(control: value, controlEvents: event) { _ in
            closure()
        }
        temp.append(target)
        value.kit_controlTargets = temp
        return self
    }

    @discardableResult
    func on(_ event: UIControl.Event = .touchUpInside, _ closure: @escaping (T) -> Void) -> ThenExtension {
        var temp: [ControlTarget] = value.kit_controlTargets ?? []
        let target = ControlTarget(control: value, controlEvents: event) { _ in
            closure(self.value)
        }
        temp.append(target)
        value.kit_controlTargets = temp
        return self
    }

    @discardableResult
    func off(for event: UIControl.Event = .touchUpInside) -> ThenExtension {
        value.kit_controlTargets?.filter { $0.controlEvents == event }.forEach { $0.dispose() }
        value.kit_controlTargets = value.kit_controlTargets?.filter { $0.controlEvents != event }
        return self
    }

    @discardableResult
    func on(_ events: [UIControl.Event], _ closure: @escaping @autoclosure () -> Void) -> ThenExtension {
        events.forEach { on($0, closure()) }
        return self
    }

    @discardableResult
    func on(_ events: [UIControl.Event], _ closure: @escaping (T) -> Void) -> ThenExtension {
        events.forEach { on($0, closure) }
        return self
    }

    @discardableResult
    func off(for events: [UIControl.Event]) -> ThenExtension {
        events.forEach { off(for: $0) }
        return self
    }
}

private final class ControlTarget: NSObject {
    weak var control: UIControl?
    let selector: Selector = #selector(ControlTarget.eventHandler(_:))
    let controlEvents: UIControl.Event
    var callback: ((UIControl) -> Void)?

    fileprivate init(control: UIControl, controlEvents: UIControl.Event, callback: ((UIControl) -> Void)?) {
        self.control = control
        self.controlEvents = controlEvents
        self.callback = callback
        super.init()
        control.addTarget(self, action: selector, for: controlEvents)
    }

    @objc
    fileprivate func eventHandler(_ sender: UIControl) {
        if let callback = callback, let control = control {
            callback(control)
        }
    }

    fileprivate func dispose() {
        control?.removeTarget(self, action: selector, for: controlEvents)
        callback = nil
    }
}

private extension NSObject {
    var kit_controlTargets: [ControlTarget]? {
        get { then.binded(for: UIControlAssociation.target) }
        set { then.bind(object: newValue, for: UIControlAssociation.target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UIButton {
    fileprivate var kit_delayInterval: TimeInterval? {
        get { then.binded(for: UIControlAssociation.delay) }
        set { then.bind(object: newValue, for: UIControlAssociation.delay, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    fileprivate var kit_lastResponseTimeInt: TimeInterval? {
        get { then.binded(for: UIControlAssociation.timeInt) }
        set { then.bind(object: newValue, for: UIControlAssociation.timeInt, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard let delay = kit_delayInterval else {
            super.sendAction(action, to: target, for: event)
            return
        }
        guard let lt = kit_lastResponseTimeInt else {
            super.sendAction(action, to: target, for: event)
            kit_lastResponseTimeInt = Date().timeIntervalSince1970
            return
        }
        if Date().timeIntervalSince1970 - lt > delay {
            super.sendAction(action, to: target, for: event)
            kit_lastResponseTimeInt = Date().timeIntervalSince1970
        }
    }
}

private enum UIControlAssociation {
    @UniqueAddress static var delay
    @UniqueAddress static var timeInt
    @UniqueAddress static var target
}
