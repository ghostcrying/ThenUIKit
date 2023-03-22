//
//  UIView+Loading.swift
//  ThenUIKit
//
//  Created by 陈卓 on 2023/3/22.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: ViewableType {
    
    var loading: UIViewLoadingProxy {
        return UIViewLoadingProxy(base: base)
    }
}

public class UIViewLoadingProxy {
    
    private var base: ViewableType
    fileprivate init(base: ViewableType) {
        self.base = base
    }
    
    private static var bindedKey: String = "com.then.uikit.loading.bind.key"
    
    private var activityView: UIActivityIndicatorView? {
        get { return base.view.then.binded(for: &UIViewLoadingProxy.bindedKey) }
        set { base.view.then.bind(object: newValue, for: &UIViewLoadingProxy.bindedKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public func start(style: UIActivityIndicatorView.Style = .gray, offset: CGPoint = .zero) {
        if let act = activityView {
            if act.superview == nil {
                base.addSub(act)
                makeCenterConstrains(base, act, offset)
            }
            base.bringSubviewToFront(act)
            act.startAnimating()
            return
        }
        let nact = UIActivityIndicatorView(style: style)
        nact.hidesWhenStopped = true
        base.addSub(nact)
        makeCenterConstrains(base, nact, offset)
        nact.startAnimating()
        activityView = nact
    }
    
    public func stop() {
        activityView?.stopAnimating()
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    public var loading: Bool {
        get {
            guard let act = activityView, let _ = act.superview else { return false }
            return act.isAnimating
        }
        set {
            newValue ? start() : stop()
        }
    }
    
    private func makeCenterConstrains(_ target: ViewableType, _ subView: ViewableType, _ offset: CGPoint = .zero) {
        subView.view.translatesAutoresizingMaskIntoConstraints = false
        let constraintX = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: .equal,
                                             toItem: target, attribute: .centerX, multiplier: 1, constant: offset.x)
        let constraintY = NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: .equal,
                                             toItem: target, attribute: .centerY, multiplier: 1, constant: offset.y)
        target.view.addConstraints([constraintX, constraintY])
    }
}


