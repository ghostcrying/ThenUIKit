//
//  ThenActivityIndicatorView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
 
public extension ThenActivityIndicatorView {
    
    /// 对应 UIActivityIndicatorView Large Style
    static var largeView: ThenActivityIndicatorView {
        let view = ThenActivityIndicatorView(width: 37.0)
        view.indicatorCount = 8
        view.indicatorWidth = 5.0
        view.indicatorHeight = 12.0
        return view
    }
    
    /// 对应 UIActivityIndicatorView Medium Style
    static var mediumView: ThenActivityIndicatorView {
        let view = ThenActivityIndicatorView(width: 20.0)
        view.indicatorCount = 8
        view.indicatorWidth = 2.5
        view.indicatorHeight = 7.0
        return view
    }
}

/// Custom UIActivityIndicatorView
public class ThenActivityIndicatorView: UIView {
        
    //MARK: - Public Properties
    public private(set) var isAnimating: Bool = false
    
    /// 刻度颜色
    public var color: UIColor = UIColor.black {
        didSet {
            guard oldValue != color else { return }
            self.shapelayer.backgroundColor = color.cgColor
        }
    }
    /// 刻度数量
    public var indicatorCount: Int = 8 {
        didSet {
            guard indicatorCount != oldValue else { return }
            self.groupAnimation.duration = 0.1 * Double(indicatorCount)
            self.replicatorLayer.instanceCount = indicatorCount
            self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(indicatorCount), 0, 0, 1.0)
        }
    }
    /// 刻度宽度
    public var indicatorWidth: CGFloat = 5 {
        didSet {
            guard oldValue != indicatorWidth else { return }
            shapelayer.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
            shapelayer.cornerRadius = indicatorWidth / 2
        }
    }
    /// 刻度高度
    public var indicatorHeight: CGFloat = 12 {
        didSet {
            guard oldValue != indicatorHeight else { return }
            shapelayer.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
            shapelayer.position = CGPoint(x: Width / 2, y: indicatorHeight / 2)
        }
    }
    
    
    //MARK: - Private Properties
    private var Width: CGFloat = 37.0
    
    private let AnimateKey = "activity.animate.alpha.key"

    
    //MARK: - Main
    private lazy var groupAnimation: CAAnimationGroup = {
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = NSNumber(0.2)
        alphaAnimation.toValue = NSNumber(1)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [alphaAnimation]
        groupAnimation.repeatCount = HUGE
        groupAnimation.duration = 0.1 * Double(indicatorCount)
        return groupAnimation
    }()

    private lazy var shapelayer: CAShapeLayer = {
        let shapelayer = CAShapeLayer()
        shapelayer.backgroundColor = color.cgColor
        shapelayer.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
        shapelayer.position = CGPoint(x: Width / 2, y: indicatorHeight / 2)
        shapelayer.cornerRadius = indicatorWidth / 2 + 0.1
        return shapelayer
    }()
     
    private lazy var replicatorLayer: CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: Width, height: Width)
        replicatorLayer.instanceCount = indicatorCount
        replicatorLayer.instanceDelay = 0.1
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(indicatorCount), 0, 0, 1.0)
        return replicatorLayer
    }()
        
    
    //MARK: - Init
    public convenience init(width: CGFloat = 37.0) {
        self.init(frame: CGRect.init(x: 0, y: 0, width: width, height: width))
        self.Width = width
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ThenActivityIndicatorView {
    
    final func startAnimating() {
        guard !isAnimating else { return }
        self.isAnimating = true
        
        self.shapelayer.add(groupAnimation, forKey: AnimateKey)
        self.replicatorLayer.addSublayer(shapelayer)
        self.layer.addSublayer(replicatorLayer)
    }
    
    final func stopAnimating() {
        guard isAnimating else { return }
        self.isAnimating = false

        self.shapelayer.removeAnimation(forKey: AnimateKey)
        self.replicatorLayer.removeFromSuperlayer()
        self.shapelayer.removeFromSuperlayer()
    }
}
