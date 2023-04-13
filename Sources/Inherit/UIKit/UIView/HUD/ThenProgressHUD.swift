//
//  ThenProgressHUD.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/1.
//

import UIKit

//MARK: - static
extension ThenProgressHUD {
    // 查找
    static public func hudfor(_ parent: UIView? = nil) -> ThenProgressHUD? {
        var view = parent
        if view == nil {
            view = UIApplication.shared.window
        }
        guard let view = view else {
            return nil
        }
        for subview in view.subviews.reversed() {
            if subview.isKind(of: self), let hud = subview as? ThenProgressHUD {
                if !hud.hasFinished {
                    return hud
                }
            }
        }
        return nil
    }
    
    /// 展示
    @discardableResult
    static public func show(parent: UIView? = nil, style: ThenProgressHUDStyle) -> ThenProgressHUD? {
        var view = parent
        if view == nil {
            view = UIApplication.shared.window
        }
        guard let view = view else {
            return nil
        }
        hudfor(view)?.hide()
        let hud = ThenProgressHUD(frame: view.bounds, style: style)
        hud.isHidden = true
        view.addSubview(hud)
        return hud
    }
    
    // 隐藏
    static public func hide(_ parent: UIView? = nil) {
        var view = parent
        if view == nil {
            view = UIApplication.shared.window
        }
        guard let view = view, let hud = hudfor(view) else {
            return
        }
        hud.hide()
    }
}

/// 自定义HUD
public class ThenProgressHUD: UIView {

    //MARK: - Views
    lazy var indicator: UIActivityIndicatorView = {
        let activity: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .medium)
            activity.color = UIColor.white
        } else {
            activity = UIActivityIndicatorView(style: .white)
            activity.tintColor = UIColor.white
        }
        activity.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activity.hidesWhenStopped = true
        return activity
    }()
    
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        // 行间距
        style.lineSpacing = 4
        return style
    }()
    
    
    //MARK: - Properties
    /// 点击事件是否穿透: 默认不穿透
    public var dimBackground: Bool = true {
        didSet {
            self.isUserInteractionEnabled = !dimBackground
        }
    }
    /// 边距, 设定在title属性之前
    public var margin: CGFloat = 16
    /// 标题文本
    public var title: String = "" {
        didSet {
            self.titlelabel.text = title
            switch style {
            case .indeterminateText:
                // 长度不一致才修改布局
                guard oldValue.count != title.count else { return }
                let w = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 14), options: .usesFontLeading, attributes: [NSAttributedString.Key.font: self.titlelabel.font ?? UIFont.systemFont(ofSize: 11)], context: nil).size.width
                let width = max(w + margin * 2, 90)
                self.contentView.frame = CGRect(x: bounds.size.width / 2 - width / 2, y: bounds.size.height / 2 - width / 2, width: width, height: width)
                let indicatorY = (width - (self.indicator.bounds.size.height + margin + 14)) / 2
                self.indicator.center = CGPoint(x: width / 2, y: indicatorY + indicator.bounds.size.height / 2)
                self.titlelabel.frame = CGRect(x: 0, y: indicatorY + indicator.bounds.size.height + margin, width: width, height: 14)
                self.titlelabel.isHidden = false
                
            case .text(let position):
                let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                self.titlelabel.attributedText = NSMutableAttributedString(string: title, attributes: attributes)
                let maxW = UIScreen.main.bounds.size.width - 80 - 48
                let size = (title as NSString).boundingRect(with: CGSize(width: maxW, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
                // print("当前大小: \(size.width) \(size.height) \n最大宽度: \(maxW)")
                switch position {
                case .center:
                    if size.height < 20 {
                        self.contentView.frame = CGRect(x: (UIScreen.main.bounds.size.width - size.width - 48) / 2, y: UIScreen.main.bounds.size.height / 2 - 22, width: size.width + 48, height: 44)
                        // 单行文本
                        self.titlelabel.frame = CGRect(x: 24, y: 12, width: size.width, height: 20)
                    } else {
                        self.frame = CGRect(x: (UIScreen.main.bounds.size.width - size.width - 48) / 2, y: UIScreen.main.bounds.size.height / 2 - size.height / 2 - 12, width: size.width + 48, height: size.height + 24)
                        self.contentView.frame = self.bounds
                        self.titlelabel.frame = CGRect(x: 24, y: 12, width: size.width, height: size.height)
                    }
                case .bottom:
                    let bottom = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 40
                    if size.height < 20 {
                        self.contentView.frame = CGRect(x: (UIScreen.main.bounds.size.width - size.width - 48) / 2, y: UIScreen.main.bounds.size.height - 44 - bottom, width: size.width + 48, height: 44)
                        // 单行文本
                        self.titlelabel.frame = CGRect(x: 24, y: 12, width: size.width, height: 20)
                    } else {
                        self.contentView.frame = CGRect(x: (UIScreen.main.bounds.size.width - size.width - 48) / 2, y: UIScreen.main.bounds.size.height - size.height - 24 - bottom, width: size.width + 48, height: size.height + 24)
                        // 多行文本
                        self.titlelabel.frame = CGRect(x: 24, y: 12, width: size.width, height: size.height)
                    }
                }
                self.titlelabel.isHidden = false
                
            default:
                self.titlelabel.isHidden = true
                self.contentView.center = self.center
                break
            }
        }
    }
    /// 默认菊花视图
    private var style: ThenProgressHUDStyle = .indeterminate
    /// 是否显示结束
    private var hasFinished: Bool = true
    
    
    //MARK: - Lifecycle
    public required init(frame: CGRect, style: ThenProgressHUDStyle) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = !dimBackground
        self.style = style
        self.addSubview(contentView)
        
        switch style {
        case .indeterminate:
            contentView.layer.cornerRadius = 8
            contentView.bounds = CGRect(x: 0, y: 0, width: 64, height: 64)
            contentView.center = self.center
            indicator.center = CGPoint(x: 32, y: 32)
            indicator.startAnimating()
            contentView.addSubview(indicator)
        case .text:
            contentView.layer.cornerRadius = 4
            titlelabel.font = UIFont.systemFont(ofSize: 14)
            contentView.frame = CGRect()
            contentView.addSubview(titlelabel)
        case .indeterminateText:
            contentView.layer.cornerRadius = 8
            titlelabel.font = UIFont.systemFont(ofSize: 11)
            contentView.frame = CGRect(x: frame.size.width / 2 - 45, y: frame.size.height / 2 - 45, width: 90, height: 90)
            indicator.center = CGPoint(x: 45, y: 45 - (margin + 14) / 2)
            indicator.startAnimating()
            contentView.addSubview(indicator)
            contentView.addSubview(titlelabel)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - public
extension ThenProgressHUD {
    
    public func show(duration: TimeInterval = 0, animate: Bool = true) {
        self.hasFinished = false
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.isHidden = false
            }
        } else {
            self.isHidden = false
        }
        if duration > 0 {
            self.hide(delay: duration, animate: animate)
        }
    }
    
    public func hide(delay duration: TimeInterval = 3.0, animate: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hide(animate: animate)
        }
    }
    
    public func hide(animate: Bool = false) {
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.isHidden = true
            } completion: { value in
                if value {
                    self.removeFromSuperview()
                    self.hasFinished = true
                }
            }
        } else {
            self.isHidden = true
            self.removeFromSuperview()
            self.hasFinished = true
        }
    }
}


/// 主显示样式
public enum ThenProgressHUDStyle: Equatable {
    // 菊花
    case indeterminate
    // 文本
    case text(position: ThenProgressHUDTextPosition = .center)
    // 菊花+文本
    case indeterminateText
}

/// 单文本样式
public enum ThenProgressHUDTextPosition {
    case center
    case bottom
}
