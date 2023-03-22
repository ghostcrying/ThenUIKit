//
//  UIView+IBInspectable.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit

public extension UIView {
    
    @IBInspectable
    var layerShadowOffset: CGSize {
        get { layer.shadowOffset }
        set {
            guard newValue != layer.shadowOffset else { return }
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var layerShadowOpacity: Float {
        get { layer.opacity }
        set {
            guard newValue != layer.opacity else { return }
            layer.opacity = newValue
        }
    }
    
    @IBInspectable
    var layerShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return .init(cgColor: color)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            guard newValue != cornerRadius else { return }
            layer.cornerRadius = newValue
            if layer.masksToBounds == false {
                layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            guard newValue != layer.borderWidth else { return }
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return .init(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
