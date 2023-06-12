//
//  UIImageView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/20.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIImageView {
    
    /// blur
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> ThenExtension {
        value.blur(withStyle: style)
        return self
    }
}

public extension UIImageView {
    
    /// ThenUIKit: Make image view blurry.
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }

}
