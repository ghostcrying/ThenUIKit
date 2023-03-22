//
//  UIView+Xib.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIView {
    
    @discardableResult
    static func loadXib(_ bundle: Bundle = Bundle.main, _ index: Int = 0) -> T {
        return T.loadXib(bundle, index)
    }
}

public protocol ThenLoadXib { }

public extension ThenLoadXib {
    
    @discardableResult
    static func loadXib(_ bundle: Bundle = .main, _ index: Int = 0) -> Self {
        return bundle.loadNibNamed(String(describing: self), owner: self, options: nil)?[index] as! Self
    }
}

extension UIView: ThenLoadXib { }
