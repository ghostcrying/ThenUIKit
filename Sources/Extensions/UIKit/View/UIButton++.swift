//
//  UIButton++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/21.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIButton {
    
    @discardableResult
    func setTitle(_ title: String?, for state: UIControl.State) -> ThenExtension {
        value.setTitle(title, for: state)
        return self
    }

    @discardableResult
    func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> ThenExtension {
        value.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) -> ThenExtension {
        value.setTitleShadowColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setImage(_ image: UIImage?, for state: UIControl.State) -> ThenExtension {
        value.setImage(image, for: state)
        return self
    }

    @discardableResult
    func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) -> ThenExtension {
        value.setBackgroundImage(image, for: state)
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) -> ThenExtension {
        value.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }

    @available(iOS 6.0, *)
    @discardableResult
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) -> ThenExtension {
        value.setAttributedTitle(title, for: state)
        return self
    }
}
