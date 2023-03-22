//
//  ThenInputFieldCell.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/22.
//

import UIKit

extension ThenInputField {
    
    class ThenInputFieldCell: UICollectionViewCell {
        
        static let Identifier = "com.then.input.cell"
        
        private let CursoryAnimationKey = "com.then.input.cursor.animate.key"
        
        
        //MARK: - Public
        public var isShowCursor: Bool = true
                    
        public var configuration = InputConfiguration() {
            didSet {
                //
                self.cursorView.backgroundColor = configuration.cursorColor
                self.cursorWidthsConstrant.constant = configuration.cursorWidth
                self.cursorHeightConstrant.constant = configuration.cursorHeight
                
                self.layer.cornerRadius = configuration.cornerRadius
                self.layer.borderWidth = configuration.borderWidth
                
                self.configlineView()
                self.configSecurityView()
                self.configValuelabel()
            }
        }
                
        public var isEditSelected: Bool = false {
            didSet {
                /// layer
                if isEditSelected {
                    self.layer.borderColor = configuration.borderColorSelect.cgColor
                    self.backgroundColor = configuration.backColorSelect
                } else {
                    let isFilled = valuelabel.text?.isEmpty == false
                    if isFilled {
                        self.layer.borderColor = configuration.borderColorFilled?.cgColor ?? configuration.borderColorNormal.cgColor
                        self.backgroundColor = configuration.backColorFilled ?? configuration.backColorNormal
                    } else {
                        self.layer.borderColor = configuration.borderColorNormal.cgColor
                        self.backgroundColor = configuration.backColorNormal
                    }
                }
                
                /// lineView
                if let lineView = lineView {
                    if isEditSelected {
                        lineView.lineView.backgroundColor = lineView.selectColor
                    } else {
                        if configuration.originText.isEmpty {
                            lineView.lineView.backgroundColor = lineView.normalColor
                        } else {
                            lineView.lineView.backgroundColor = lineView.filledColor
                        }
                    }
                    lineView.isSelected = isEditSelected
                }
                
                /// cursor
                if isShowCursor {
                    if isEditSelected {
                        self.cursorView.isHidden = false
                        self.cursorView.layer.add(self.opacityAnimation, forKey: CursoryAnimationKey)
                    } else {
                        self.cursorView.isHidden = true
                        self.cursorView.layer.removeAnimation(forKey: CursoryAnimationKey)
                    }
                } else {
                    self.cursorView.isHidden = true
                }
            }
        }
        
        
        //MARK: - Private Views
        lazy var valuelabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 35)
            return label
        }()
        
        lazy var opacityAnimation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1.0
            animation.toValue = 0.0
            animation.duration = 1
            animation.repeatCount = MAXFLOAT
            animation.isRemovedOnCompletion = true
            animation.fillMode = .both
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            return animation
        }()
        
        lazy var cursorView: UIView = {
            return UIView()
        }()
        
        var lineView: ThenInputLineView?
        
        var securityView: UIView?

        
        //MARK: - properties
        var cursorWidthsConstrant: NSLayoutConstraint!
        var cursorHeightConstrant: NSLayoutConstraint!
        
        
        //MARK: - Lifecycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.isUserInteractionEnabled = false
            self.backgroundColor = UIColor.clear
            self.contentView.backgroundColor = UIColor.clear
            
            valuelabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(valuelabel)
            NSLayoutConstraint.activate([
                self.valuelabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
                self.valuelabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
                self.valuelabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.valuelabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            ])
            
            cursorView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(cursorView)
            NSLayoutConstraint.activate([
                self.cursorView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.cursorView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            ])
            self.cursorWidthsConstrant = self.cursorView.widthAnchor.constraint(equalToConstant: configuration.cursorWidth)
            self.cursorWidthsConstrant.isActive = true
            self.cursorHeightConstrant = self.cursorView.heightAnchor.constraint(equalToConstant: configuration.cursorHeight)
            self.cursorHeightConstrant.isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.configuration.shadowClosure?(self.layer)
        }
        
    }

}

extension ThenInputField.ThenInputFieldCell {
          
    func configlineView() {
        guard configuration.showline, lineView == nil else {
            return
        }
        lineView = configuration.customlineViewClosure()
        lineView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lineView!)
        NSLayoutConstraint.activate([
            self.lineView!.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.lineView!.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.lineView!.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.lineView!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func configSecurityView() {
        guard isShowCursor, securityView == nil, let view = configuration.customSecurityViewClosure?() else {
            return
        }
        securityView = view
        securityView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(securityView!)
        NSLayoutConstraint.activate([
            self.securityView!.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.securityView!.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.securityView!.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.securityView!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func configValuelabel() {
        
        self.valuelabel.isHidden = false
        self.securityView?.isHidden = true
        
        let defaultTextConfig = { [weak self] in guard let `self` = self else { return }
            self.valuelabel.font = self.configuration.textFont
            self.valuelabel.textColor = self.configuration.textColor
        }
        let placeholderTextConfig = { [weak self] in guard let `self` = self else { return }
            self.valuelabel.font = self.configuration.placeholderFont
            self.valuelabel.textColor = self.configuration.placeholderColor
        }
        if self.configuration.originText.isEmpty {
            if self.configuration.placeholderText?.isEmpty == false {
                self.valuelabel.text = self.configuration.placeholderText ?? ""
                placeholderTextConfig()
            } else {
                self.valuelabel.text = ""
                defaultTextConfig()
            }
        } else {
            if self.configuration.isShowSecurity {
                switch self.configuration.securityType {
                case .symbol:
                    self.valuelabel.text = self.configuration.securitySymbol
                default:
                    self.valuelabel.isHidden = true
                    self.securityView?.isHidden = false
                }
            } else {
                self.valuelabel.text = self.configuration.originText
            }
            defaultTextConfig()
        }
    }
    
}

extension ThenInputField {
    
    public class ThenInputFieldFlowLayout: UICollectionViewFlowLayout {
        
        ///
        var isEqualGap: Bool = true
        
        /// the count of cell
        var itemsCount: Int = 1
        
        /// space
        public var minLineSpacing: CGFloat = 10
        
        public override func prepare() {
            
            scrollDirection = .horizontal
            
            if self.isEqualGap {
                self.autoCalucateLineSpacing()
            }
            
            super.prepare()
            
            // 平行间距
            // minimumLineSpacing
            // 垂直间距
            // minimumInteritemSpacing
        }
        
        func autoCalucateLineSpacing() {
            guard self.itemsCount > 1, let collectionView = self.collectionView else {
                self.minimumLineSpacing = self.minLineSpacing
                return
            }
            let w = collectionView.frame.width
            let l = collectionView.contentInset.left
            let r = collectionView.contentInset.right
            let space = floor((w - CGFloat(itemsCount) * itemSize.width - l - r) / CGFloat(itemsCount - 1))
            self.minimumLineSpacing = max(space, self.minLineSpacing)
        }
        
    }
}
