//
//  UIAlertController+Inputs.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/14.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIAlertController {
    
    /// Add textFields 2~4
    /// - Parameter config: ...
    @discardableResult
    func addTextFields(config: UIAlertController.AlertTextFieldConfig) -> ThenExtension {
        value.addTextFields(config: config)
        return self
    }
}

public extension UIAlertController {
    
    /// Add textFields 2~4
    /// - Parameter config: ...
    func addTextFields(config: AlertTextFieldConfig) {
        guard config.configurations.count > 1 && config.configurations.count < 5 else {
            return
        }
        let textField = TextFieldsViewController(config: config)
        set(vc: textField, height: config.height * 2 + config.vInset * 2)
    }
    
    struct AlertTextFieldConfig {
        // 边距
        let hInset: CGFloat
        let vInset: CGFloat
        
        /// 单TextField高度
        let height: CGFloat
        
        let configurations: [ThenTextField.Config]
        
        public init(hInset: CGFloat = 8, vInset: CGFloat = 0, height: CGFloat, configurations: [ThenTextField.Config]) {
            self.hInset = hInset
            self.vInset = vInset
            self.height = height
            self.configurations = configurations
        }
    }
    
}

final class TextFieldsViewController: UIViewController {
    
    fileprivate lazy var contentView: UIView = {
        let v = UIView(frame: .zero)
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate var textFields = [ThenTextField]()
    
    fileprivate var config: UIAlertController.AlertTextFieldConfig
    
    private var widthConstraint: NSLayoutConstraint?
    
    required init(config: UIAlertController.AlertTextFieldConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // print("has deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(contentView)
        
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: view.then.width - config.hInset * 2)
        widthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: config.hInset),
            contentView.heightAnchor.constraint(equalToConstant: config.height * 2),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])
        
        let count = config.configurations.count
        for i in 0..<count {
            let textfiled = ThenTextField()
            textfiled.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(textfiled)
            NSLayoutConstraint.activate([
                textfiled.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                textfiled.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                textfiled.topAnchor.constraint(equalTo: contentView.topAnchor, constant: config.height * CGFloat(i)),
                textfiled.heightAnchor.constraint(equalToConstant: config.height),
            ])
            textFields.append(textfiled)
            
            config.configurations[i](textfiled)
        }
        
        preferredContentSize.height = config.height * CGFloat(count) + config.vInset * 2
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.widthConstraint?.constant = view.then.width - config.hInset * 2
    }
    
}

