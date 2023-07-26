//
//  ThenLaunch+UIView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/25.
//

import UIKit

extension UIView {
    
    var subImageViewRects: [CGRect] {
        return subImageViews.compactMap {
            let imageFrame = $0.convert($0.bounds, to: self)
            let imageRect  = $0.image?.rect(with: $0.contentMode, in: $0.bounds.size, clipsToBounds: $0.clipsToBounds) ?? .zero
            
            let x = imageFrame.minX + imageRect.minX
            let y = imageFrame.minY + imageRect.minY
            let w = imageRect.width
            let h = imageRect.height
            
            return CGRect(x: x, y: y, width: w, height: h)
        }
    }
        
}

extension Bundle {
    
    /// 获取launchScreen上关于UIImage的所有位置数据
    func launchImageViewRects(_ isPortrait: Bool) -> [CGRect]? {
        switch isPortrait {
        case true:
            guard let view = launchScreenController?.view, isSupportPortrait else {
                return nil
            }
            view.bounds = CGRect(x: 0,
                                 y: 0,
                                 width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                                 height: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
            view.setNeedsLayout()
            view.layoutIfNeeded()
            return view.subImageViewRects
        default:
            guard let view = launchScreenController?.view, isSupportlandscape else {
                return nil
            }
            view.bounds = CGRect(x: 0,
                                 y: 0,
                                 width: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                                 height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
            view.setNeedsLayout()
            view.layoutIfNeeded()
            return view.subImageViewRects
        }
    }
}
