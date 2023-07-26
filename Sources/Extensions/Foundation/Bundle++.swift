//
//  Bundle++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/25.
//

import UIKit
import Foundation

public extension Bundle {
     
    var launchScreenController: UIViewController? {
        guard let storyboardName = infoDictionary?["UILaunchStoryboardName"] as? String else {
            return nil
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    var isSupportPortrait: Bool {
        guard let orientations = Bundle.main.infoDictionary?["UISupportedInterfaceOrientations"] as? [String] else {
            return true
        }
        return orientations.contains {
            $0 == "UIInterfaceOrientationPortrait" || $0 == "UIInterfaceOrientationPortraitUpsideDown"
        }
    }
    
    var isSupportlandscape: Bool {
        guard let orientations = Bundle.main.infoDictionary?["UISupportedInterfaceOrientations"] as? [String] else {
            return true
        }
        return orientations.contains {
            $0 == "UIInterfaceOrientationLandscapeLeft" || $0 == "UIInterfaceOrientationLandscapeRight"
        }
    }
    
    /// 启动图文件是否包含安全区域约束
    var containSafeAreaLayoutGuide: Bool {
        guard let view = launchScreenController?.view else {
            return false
        }
        
        let guide = view.safeAreaLayoutGuide
        for constraint in view.constraints {
            if constraint.firstItem === guide && constraint.secondItem !== view {
                return true
            }
            if constraint.secondItem === guide && constraint.firstItem !== view {
                return true
            }
        }
        return false
    }
}

// MARK: - UserInterfaceStyle
public enum UserInterfaceStyle: Int {
    case system = 0
    case light = 1
    case dark = 2
}

public extension Bundle {
    
    var interfaceStyle: UserInterfaceStyle {
        if #available(iOS 13.0, *), let style = infoDictionary?["UIUserInterfaceStyle"] as? String {
            if style == "Automatic" {
                return .system
            }
            if style == "Light" {
                return .light
            }
            if style == "Dark" {
                return .dark
            }
        }
        return .light
    }
    
}
