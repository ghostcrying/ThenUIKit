//
//  UIApplication++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/15.
//

import UIKit
import ThenFoundation

public extension UIApplication {
    
    /// 适配iOS13的Window处理
    var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared
                .connectedScenes
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?
                .windows
                .first
        } else {
            return UIApplication.shared.delegate?.window as? UIWindow
        }
    }
}

public extension ThenExtension where T: UIApplication {
        
    var rootController: UIViewController? {        
        return findTop(base.window?.rootViewController)
    }
    
    /// exit application
    func exit() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        DispatchQueue.main.then.delay(1) { Darwin.exit(EXIT_SUCCESS) }
    }
    
    var orientationTransform: CGAffineTransform {
        switch base.statusBarOrientation {
        case .portrait:             return .identity
        case .portraitUpsideDown:   return CGAffineTransform(rotationAngle: .pi)
        case .landscapeLeft:        return CGAffineTransform(rotationAngle: .pi / -2.0)
        case .landscapeRight:       return CGAffineTransform(rotationAngle: .pi /  2.0)
        case .unknown:              return .identity
        @unknown default:           return .identity
        }
    }
    
}

private func findTop(_ viewController: UIViewController?) -> UIViewController? {
    
    guard let vc = viewController else { return nil }
    
    if let tab = vc as? UITabBarController {
        return findTop(tab.selectedViewController)
    }
    if let nav = vc as? UINavigationController {
        return findTop(nav.topViewController)
    }
    if let presented = vc.presentedViewController {
        return findTop(presented)
    }
    return viewController
}
