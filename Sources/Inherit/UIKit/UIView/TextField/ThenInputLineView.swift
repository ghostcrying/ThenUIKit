//
//  ThenInputLineView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/22.
//

import UIKit

internal let ThenInputFieldMasterColor = UIColor(red: 49/255.0, green: 51/255.0, blue: 64/255.0, alpha: 1)

public class ThenInputLineView: UIView {
    
    public var normalColor: UIColor = ThenInputFieldMasterColor
    
    public var selectColor: UIColor = ThenInputFieldMasterColor
    
    public var filledColor: UIColor = ThenInputFieldMasterColor
    
    public var selectClosure: ((ThenInputLineView, Bool) -> ())?
    
    /// The lineView left padding
    public var lineleftPadding: CGFloat = 0 {
        didSet {
            guard lineleftPadding != oldValue else { return }
            self.lineleftConstrant.constant = lineleftPadding
        }
    }
    /// The lineView height
    public var lineHeight: CGFloat = 4 {
        didSet {
            guard lineHeight != oldValue else { return }
            self.lineHeightConstrant.constant = lineHeight
        }
    }
    
    private var lineleftConstrant: NSLayoutConstraint!
    private var lineHeightConstrant: NSLayoutConstraint!
    
    lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = self.normalColor
        v.layer.cornerRadius = 2
        v.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        return v
    }()
    
    var isSelected: Bool = false {
        didSet {
            self.selectClosure?(self, isSelected)
        }
    }
    
    // MARK: - Lifecycle
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
                    
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        NSLayoutConstraint.activate([
            self.lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.lineleftConstrant = self.lineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: lineleftPadding)
        self.lineleftConstrant.isActive = true
        self.lineHeightConstrant = self.lineView.heightAnchor.constraint(equalToConstant: lineHeight)
        self.lineHeightConstrant.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ThenInputField {
    
    class TextField: UITextField {
        
        /// Pasting and copying are prohibited
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false
        }
    }
}
