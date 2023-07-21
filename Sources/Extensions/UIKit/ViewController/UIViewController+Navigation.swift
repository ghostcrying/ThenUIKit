//
//  UIViewController+Navigation.swift
//  ThenUIKit
//
//  Created by ghost on 2020/5/6.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T : UIViewController {
    
    var isRoot: Bool {
        return value.navigationController?.viewControllers.first == value
    }
}

public extension ThenExtension where T : UIViewController {
    
    func filter(without withoutType: UIViewController.Type) {
        value.filter(without: [withoutType])
    }
    
    func filter(without withoutTypes: [UIViewController.Type]) {
        value.filter(without: withoutTypes)
    }
    
    func navigationPrefixToSelf(without withoutTypes: [UIViewController.Type] = []) {
        value.navigationPrefixToSelf(without: withoutTypes)
    }
    
    func navigationSuffixToSelf(without withoutTypes: [UIViewController.Type] = []) {
        value.navigationSuffixToSelf(without: withoutTypes)
    }
    
    func navigationPrefix(to toType: UIViewController.Type, without withoutTypes: [UIViewController.Type] = []) {
        value.navigationPrefix(to: toType, without: withoutTypes)
    }
    
    func navigationSuffix(to toType: UIViewController.Type, without withoutTypes: [UIViewController.Type] = []) {
        value.navigationSuffix(to: toType, without: withoutTypes)
    }
}

extension UIViewController {
    
    func filter(without withoutTypes: [UIViewController.Type]) {
        navigationController?.viewControllers = navigationController?.viewControllers.filter { vc in !withoutTypes.contains { t in t === type(of: vc) } } ?? [self]
    }
    
    func navigationPrefixToSelf(without withoutTypes: [UIViewController.Type]) {
        return navigationPrefix(to: type(of: self), without: withoutTypes)
    }
    
    func navigationSuffixToSelf(without withoutTypes: [UIViewController.Type]) {
        return navigationSuffix(to: type(of: self), without: withoutTypes)
    }
    
    func navigationPrefix(to toType: UIViewController.Type, without withoutTypes: [UIViewController.Type]) {
        guard let navVc = navigationController else { return }
        var vcs = navVc.viewControllers.filter { vc in !withoutTypes.contains { t in t === type(of: vc)} }
        guard
            vcs.count > 1,
            let firstIndex = vcs.firstIndex(where: { type(of: $0) === toType }),
            firstIndex > vcs.startIndex,
            firstIndex < vcs.endIndex
            else {
                navVc.viewControllers = vcs
                return
        }
        vcs = vcs.prefix(firstIndex).compactMap { $0 }
        vcs.append(self)
        navVc.viewControllers = vcs
    }
    
    func navigationSuffix(to toType: UIViewController.Type, without withoutTypes: [UIViewController.Type] = []) {
        guard let navVc = navigationController else { return }
        let vcs = navVc.viewControllers.filter { vc in !withoutTypes.contains { t in t === type(of: vc)} }
        guard
            vcs.count > 1,
            let lastIndex = vcs.lastIndex(where: { type(of: $0) === toType }),
            lastIndex > vcs.startIndex,
            lastIndex < vcs.endIndex
            else {
                navVc.viewControllers = vcs
                return
        }
        navigationController?.viewControllers = vcs.suffix(from: lastIndex).compactMap { $0 }
    }
}

public extension UIViewController {
    /// 导航栏背景颜色
    var navigationbBarBackgroundColor: UIColor? {
        get {
            return navigationController?.navigationBar.barTintColor
        }
        set {
            guard let controller = (self as? UINavigationController) ?? navigationController else { return }
            if #available(iOS 13.0, *) {
                let appearance = controller.navigationBar.standardAppearance
                appearance.backgroundColor = newValue
                appearance.shadowColor = .clear
                controller.navigationBar.standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    controller.navigationBar.scrollEdgeAppearance = appearance
                }
            } else {
                controller.navigationBar.barTintColor = newValue
            }
        }
    }
}
