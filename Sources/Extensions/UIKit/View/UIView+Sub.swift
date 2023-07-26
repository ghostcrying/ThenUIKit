//
//  UIView+Sub.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/25.
//

import UIKit

public extension UIView {
    
    var subImageViews: [UIImageView] {
        var imageViews = [UIImageView]()
        for subview in subviews {
            imageViews += subview.subImageViews
            guard !subview.isHidden,
                  let imageView = subview as? UIImageView,
                  imageView.image != nil else {
                continue
            }
            imageViews.append(imageView)
        }
        return imageViews
    }
}
