//
//  UIAlertController++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/14.
//

import UIKit
import AudioToolbox
import ThenFoundation

public extension ThenExtension where T: UIAlertController {
    
    /// Present alert view controller in the current view controller.
    ///
    /// - Parameters:
    ///   - animated: set true to animate presentation of alert controller (default is true).
    ///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
    ///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
    @discardableResult
    func show(animated: Bool = true, vibrate: Bool = false, style: UIBlurEffect.Style? = nil, completion: (() -> Void)? = nil) -> ThenExtension {
        value.show(animated: animated, vibrate: vibrate, style: style, completion: completion)
        return self
    }
    
    /// Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    @discardableResult
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> ThenExtension {
        value.addAction(image: image, title: title, color: color, style: style, isEnabled: isEnabled, handler: handler)
        return self
    }
    
    /// Set alert's title, font and color
    ///
    /// - Parameters:
    ///   - title: alert title
    ///   - font: alert title font
    ///   - color: alert title color
    @discardableResult
    func set(title: String?, font: UIFont, color: UIColor) -> ThenExtension {
        value.set(title: title, font: font, color: color)
        return self
    }
    
    @discardableResult
    func setTitle(font: UIFont, color: UIColor) -> ThenExtension {
        value.setTitle(font: font, color: color)
        return self
    }
    
    /// Set alert's message, font and color
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - font: alert message font
    ///   - color: alert message color
    @discardableResult
    func set(message: String?, font: UIFont, color: UIColor) -> ThenExtension {
        value.set(message: message, font: font, color: color)
        return self
    }

    @discardableResult
    func setMessage(font: UIFont, color: UIColor) -> ThenExtension {
        value.setMessage(font: font, color: color)
        return self
    }
    
    /// Set alert's content viewController
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - height: height of content viewController
    @discardableResult
    func set(vc: UIViewController?, height: CGFloat? = nil) -> ThenExtension {
        value.set(vc: vc, height: height)
        return self
    }
    
}


// MARK: - Initializers
public extension UIAlertController {
    
    /// Create new alert view controller.
    ///
    /// - Parameters:
    ///   - style: alert controller's style.
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(style: UIAlertController.Style, source: UIView? = nil, title: String? = nil, message: String? = nil, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
        
        // TODO: for iPad or other views
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let root = UIApplication.shared.window?.rootViewController?.view
        
        //self.responds(to: #selector(getter: popoverPresentationController))
        if let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        } else if isPad, let source = root, style == .actionSheet {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = CGRect(x: source.bounds.midX, y: source.bounds.midY, width: 0, height: 0)
            //popoverPresentationController?.permittedArrowDirections = .down
            popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        }
        
        if let color = tintColor {
            self.view.tintColor = color
        }
    }
}

/** KVC
 *  Available in iOS 17
 *  UIAlertController: attributedTitle
 *  UIAlertController: attributedMessage
 *  UIAlertController: contentViewController
 *  UIAlertAction: image
 *  UIAlertAction: titleTextColor
 */
// MARK: - Methods
public extension UIAlertController {
    
    /// Present alert view controller in the current view controller.
    ///
    /// - Parameters:
    ///   - animated: set true to animate presentation of alert controller (default is true).
    ///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
    ///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
    @inlinable
    func show(animated: Bool = true, vibrate: Bool = false, style: UIBlurEffect.Style? = nil, completion: (() -> Void)? = nil) {
        
        /// TODO: change UIBlurEffectStyle
        if let style = style {
            for subview in view.subviews where subview.isKind(of: UIVisualEffectView.self) {
                (subview as? UIVisualEffectView)?.effect = UIBlurEffect(style: style)
            }
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.window?.rootViewController?.present(self, animated: animated, completion: completion)
            if vibrate {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    /// Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    @inlinable
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
        //let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        //let action = UIAlertAction(title: title, style: isPad && style == .cancel ? .default : style, handler: handler)
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        // button image
        if let image = image {
            action.setValue(image, forKey: "image")
        }
        
        // button title color
        if let color = color {
            action.setValue(color, forKey: "titleTextColor")
        }
        
        addAction(action)
    }
    
    /// Set alert's title, font and color
    ///
    /// - Parameters:
    ///   - title: alert title
    ///   - font: alert title font
    ///   - color: alert title color
    @inlinable
    func set(title: String?, font: UIFont, color: UIColor) {
        if title != nil {
            self.title = title
        }
        setTitle(font: font, color: color)
    }
    
    @inlinable
    func setTitle(font: UIFont, color: UIColor) {
        guard let title = self.title else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        setValue(attributedTitle, forKey: "attributedTitle")
    }
    
    /// Set alert's message, font and color
    ///
    /// - Parameters:
    ///   - message: alert message
    ///   - font: alert message font
    ///   - color: alert message color
    @inlinable
    func set(message: String?, font: UIFont, color: UIColor) {
        if message != nil {
            self.message = message
        }
        setMessage(font: font, color: color)
    }

    @inlinable
    func setMessage(font: UIFont, color: UIColor) {
        guard let message = self.message else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: attributes)
        setValue(attributedMessage, forKey: "attributedMessage")
    }
    
    /// Set alert's content viewController
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - height: height of content viewController
    @inlinable
    func set(vc: UIViewController?, height: CGFloat? = nil) {
        guard let vc = vc else {
            return
        }
        if let h = height {
            vc.preferredContentSize.height = h
            preferredContentSize.height = h
        }
        setValue(vc, forKey: "contentViewController")
    }
    
}

