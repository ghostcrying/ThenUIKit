//
//  UIView+ViewController.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIView {
    
    var currentViewController: UIViewController? {
        return base.currentViewController
    }
    
    /// Delay Interaction  Enable
    func delay(_ time: TimeInterval = 1) -> ThenExtension {
        base.delay(time)
        return self
    }
}

public extension UIView {
    
    var currentViewController: UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next{
                if responder is UIViewController {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    /// Delay Interaction  Enable
    func delay(_ time: TimeInterval) {
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.isUserInteractionEnabled = true
        }
    }
}
