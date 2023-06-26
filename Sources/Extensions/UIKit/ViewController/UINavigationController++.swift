//
//  UINavigationController++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/6/26.
//

import UIKit
import Foundation

public extension UINavigationController {
    
    /// 导航栏文本样式
    var barTextAttributes: [NSAttributedString.Key: Any] {
        set {
            if #available(iOS 13.0, *) {
                let barAppearance = navigationBar.standardAppearance
                barAppearance.titleTextAttributes = newValue
                if #available(iOS 15.0, *) {
                    navigationBar.scrollEdgeAppearance = barAppearance
                }
            } else {
                navigationBar.titleTextAttributes = newValue
            }
        }
        get {
            if #available(iOS 13.0, *) {
                return navigationBar.standardAppearance.titleTextAttributes
            } else {
                return navigationBar.titleTextAttributes ?? [:]
            }
        }
    }
    
}
