//
//  UIAlertController+Input.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/14.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIAlertController {
    
    /// Add single textField
    /// - Parameter config: ...
    @discardableResult
    func addSingleTextField(config: ThenTextField.Config?) -> ThenExtension {
        value.addSingleTextField(config: config)
        return self
    }
}

public extension UIAlertController {
        
    /// Add single textField
    /// - Parameter config: ...
    func addSingleTextField(config: ThenTextField.Config?) {
        let textField = ThenInputController(vInset: preferredStyle == .alert ? 12 : 0, config: config)
        let height = ThenInputController.ui.height + ThenInputController.ui.vInset
        set(vc: textField, height: height)
    }
}

final class ThenInputController: UIViewController {
    
    fileprivate lazy var textField = ThenTextField()
    
    struct ui {
        static let height: CGFloat = 44
        static let hInset: CGFloat = 12
        static var vInset: CGFloat = 12
    }
    
    init(vInset: CGFloat = 12, config: ThenTextField.Config?) {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textField)
        ui.vInset = vInset
        
        /// have to set textField frame width and height to apply cornerRadius
        
        config?(textField)
        
        preferredContentSize.height = ui.height + ui.vInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // print("has deinitialized")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.then.width = view.then.width - ui.hInset * 2
        textField.then.height = ui.height
        textField.center = CGPoint(x: view.center.x, y: view.center.y - ui.vInset / 2)
    }
    
}

