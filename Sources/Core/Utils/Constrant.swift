//
//  Constrant.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/24.
//

import UIKit

public extension UIScreen {
    
    static let width  = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    
    static var isIPhone4:   Bool { return Int(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)) == 480 }
    static var isIPhone5:   Bool { return Int(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)) == 568 }
    static var isIphone6:   Bool { return Int(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)) == 667 }
    static var isIphone6p:  Bool { return Int(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)) == 736 }
    
    /// 留海屏
    /*
     机型                     尺寸   逻辑分辨率   设备分辨率     缩放因子 像素密度(PPI)
     5(s/se)                 4.0    320×568    640×1136     @2x    326
     6(s)/7/8/se2/se3        4.7    375×667    750×1334     @2x    326
     6 Plus/7 Plus/8 Plus    5.5    414×736    1080×1920    @3x    401
     X/XS/11Pro              5.8    375×812    1125×2436    @3x    458
     XR/11                   6.1    414×896    828×1792     @2x    326
     XS Max/11 Pro Max       6.5    414×896    1242×2688    @3x    458
     12Mini/13Mini           5.4    375×812    1080×2340    @3x    476
     12/13/14/12Prp/13Pro    6.1    390×844    1170×2532    @3x    460
     12PM/13PM/14Plus        6.7    428×926    1284×2778    @3x    458
     14Pro/15/15pro          6.1    393x852    1179x2556    @3x    460
     14PM/15PM/15Plus        6.7    430x932    1290x2796    @3x    460
     */
    static var isXGroup:    Bool { return Int(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)) >= 812 }
}

public struct Constants {
    
    public struct StatusBar {
        /// iPhone各屏幕状态栏高度：
        /// 机型                                                   高度（pt）
        /// iPhone 11/XR                                    48
        /// iPhone 12/12 Pro/13/13 Pro/14        47
        /// iPhone 14 Pro/14 Pro Max                59
        /// iphone                                               44
        /// iphone 8 low                                      20
        public static var height: CGFloat {
            if #available(iOS 13.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let manager = scene.statusBarManager {
                        return manager.statusBarFrame.height
                    }
                }
            }
            return UIApplication.shared.statusBarFrame.height
        }
    }

    public struct NavgationBar {
        public static let height: CGFloat = 44.0
    }
    
    public struct TabBar {
        public static let height: CGFloat = 49.0
    }
    
    public struct SafeArea {
        
        public static var top: CGFloat {
            return UIApplication.shared.window?.safeAreaInsets.top ?? 0.0
        }
        
        public static var left: CGFloat {
            return UIApplication.shared.window?.safeAreaInsets.left ?? 0.0
        }

        public static var bottom: CGFloat {
            return UIApplication.shared.window?.safeAreaInsets.bottom ?? 0.0
        }

        public static var right: CGFloat {
            return UIApplication.shared.window?.safeAreaInsets.right ?? 0.0
        }

        public static let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}


