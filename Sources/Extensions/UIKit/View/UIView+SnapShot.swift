//
//  UIView+SnapShot.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: ViewableType {
    
    func snapShot(opaque: Bool = true, scale: CGFloat = 0, afterScreenUpdates: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, opaque, scale)
        defer { UIGraphicsEndImageContext() }
        base.view.drawHierarchy(in: base.bounds, afterScreenUpdates: afterScreenUpdates)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func snapShotView(opaque: Bool = true, scale: CGFloat = 0, afterScreenUpdates: Bool = true) -> UIImageView {
        let imageView = UIImageView(frame: base.bounds)
        imageView.image = snapShot(opaque: opaque, scale: scale, afterScreenUpdates: afterScreenUpdates)
        return imageView
    }
}

