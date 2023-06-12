//
//  UIButton+EdgeInsets.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension UIButton {
    
    enum ImagePosition {
        case top
        case bottom
        case left
        case right
    }
}

public extension ThenExtension where T: UIButton {
    
    @discardableResult
    func layoutButton(position: UIButton.ImagePosition, space imageTitleSpace: CGFloat) -> ThenExtension {
        // 得到imageView和titleLabel的宽高
        let imageWidth = value.imageView?.frame.size.width ?? 0.0
        let imageHeight = value.imageView?.frame.size.height ?? 0.0
        
        let labelWidth: CGFloat = value.titleLabel?.intrinsicContentSize.width ?? 0.0
        let labelHeight: CGFloat = value.titleLabel?.intrinsicContentSize.height ?? 0.0
        
        // 初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        // 根据position和space得到imageEdgeInsets和labelEdgeInsets的值
        switch position {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-imageTitleSpace/2, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-imageTitleSpace/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-imageTitleSpace/2, left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-imageTitleSpace/2, bottom: 0, right: imageWidth+imageTitleSpace/2)
        }
        
        value.titleEdgeInsets = labelEdgeInsets
        value.imageEdgeInsets = imageEdgeInsets
        
        return self
    }
}
