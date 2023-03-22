//
//  UIView+Radar.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//
//  雷达动画

import UIKit
import ThenFoundation

public extension ThenExtension where T: ViewableType {
    
    @discardableResult
    func addRadarAnimation(beginSize size: CGSize, fillColor: UIColor = .white, expand increment: CGFloat = 30, beginAlpha: CGFloat = 0.5) -> ThenExtension {
        base.addRadarAnimation(beginSize: size, fillColor: fillColor, expand: increment, beginAlpha: beginAlpha)
        return self
    }
    
    @discardableResult
    func addRadarAnimation(inset: UIEdgeInsets = .zero, fillColor: UIColor = .white, expand increment: CGFloat = 30, beginAlpha: CGFloat = 0.5) -> ThenExtension {
        base.addRadarAnimation(inset: inset, fillColor: fillColor, expand: increment, beginAlpha: beginAlpha)
        return self
    }
    
    @discardableResult
    func removeRadarAnimation() -> ThenExtension {
        base.removeRadarAnimation()
        return self
    }
}

public extension ViewableType {
    /// 添加带圆角的矩形雷达动画，使用 view.addRadarAnimation(size: size)
    ///
    /// - Parameters:
    ///   - beginSize: 初始size
    ///   - fillColor: 填充色，默认 .white
    ///   - increment: 扩展范围
    ///   - beginAlpha: 初始透明度
    func addRadarAnimation(beginSize size: CGSize, fillColor: UIColor = .white, expand increment: CGFloat = 30, beginAlpha: CGFloat = 0.5) {
        removeRadarAnimation()
        let radarView = RectRadarAnimationView(beginFrame: CGRect(origin: .zero, size: size), expand: increment, fillColor: fillColor, beginAlpha: beginAlpha)
        radarView.targetView = self
        radarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            radarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            radarView.widthAnchor.constraint(equalToConstant: size.width),
            radarView.heightAnchor.constraint(equalToConstant: size.height),
        ])
        radarView.addAnimation()
    }
    
    /// 添加带圆角的矩形雷达动画
    ///
    /// - Parameters:
    ///   - inset: 内边距
    ///   - fillColor: 填充颜色，默认 .white
    ///   - increment: 扩展范围
    ///   - beginAlpha: 初始透明度
    ///
    ///   eg: view.addRadarAnimation()
    func addRadarAnimation(inset: UIEdgeInsets = .zero, fillColor: UIColor = .white, expand increment: CGFloat = 30, beginAlpha: CGFloat = 0.5) {
        removeRadarAnimation()
        let radarFrame = frame.inset(by: inset)
        addRadarAnimation(beginSize: radarFrame.size, fillColor: fillColor, expand: increment, beginAlpha: beginAlpha)
    }
    
    func removeRadarAnimation() {
        radarView?.removeFromSuperview()
    }
}

extension ViewableType {
    
    fileprivate weak var radarView: RectRadarAnimationView? {
        return superview?.viewWithTag(RectRadarAnimationView.Tag) as? RectRadarAnimationView
    }
}

class RectRadarAnimationView: UIView {
    
    fileprivate static let Tag: Int = 0xAAAAAA
    
    weak var targetView: ViewableType? {
        didSet {
            guard let targetView = targetView else {
                return
            }
            targetView.superview?.insertSubview(self, belowSubview: targetView)
            self.tag = RectRadarAnimationView.Tag
        }
    }
    
    private var reusableRadarCellArray: [RadarCell] = []
    
    private var isAnimation: Bool = false
    
    private var maxIncrement: CGFloat
    
    private var fillColor: UIColor
    
    private var beginAlpha: CGFloat
    
    private let addScheduleKey = "com.then.uikit.radar.add.schedule.key-\(Int.random(in: 0...9999999))"
    private let animateScheduleKey = "com.then.uikit.radar.animate.schedule.key-\(Int.random(in: 0...9999999))"
    
    deinit {
        // print(">>> RectRadarAnimationView deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(beginFrame frame: CGRect,  expand increment: CGFloat, fillColor: UIColor, beginAlpha: CGFloat) {
        self.maxIncrement = increment
        self.fillColor = fillColor
        self.beginAlpha = beginAlpha
        super.init(frame: frame.inset(by: UIEdgeInsets(-increment)))
    }
    
    override func removeFromSuperview() {
        RadarScheduler.manager.remove(for: addScheduleKey)
        AnimateScheduler.manager.remove(for: animateScheduleKey)
        super.removeFromSuperview()
    }
    
    func addAnimation() {
        RadarScheduler.manager.add(target: self, identifier: addScheduleKey) { [weak self] in
            self?.addRadarCell()
        }
        AnimateScheduler.manager.add(target: self, identifier: animateScheduleKey) { [weak self] in
            self?.radarAnimation()
        }
    }
    
    func addRadarCell() {
        let radarCell: RadarCell = { [weak self] in
            if let cell = self?.reusableRadarCellArray.safeRemoveFirst() {
                cell.progress = 0.0
                return cell
            }
            return RadarCell(beginFrame: bounds.inset(by: UIEdgeInsets(maxIncrement)), expand: maxIncrement, fillColor: fillColor, beginAlpha: beginAlpha)
        }()
        addSub(radarCell)
    }
    
    func radarAnimation() {
        subviews.forEach {
            guard let radarView = $0 as? RadarCell else {
                return
            }
            radarView.progress += 0.006
            if radarView.progress >= 1.0 {
                radarView.removeFromSuperview()
                reusableRadarCellArray.append(radarView)
            }
        }
    }
}

extension RectRadarAnimationView {
    
    private class RadarCell: UIView {
        
        /// 进度 0.0...1.0
        var progress: CGFloat = 0 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        /// 开始的矩形位置
        private var beginFrame: CGRect
        
        /// 最大扩展范围
        private var increment: CGFloat
        
        /// 填充色
        private var fillColor: UIColor
        
        /// 初始透明度
        private var beginAlpha: CGFloat
        
        init(beginFrame: CGRect, expand increment: CGFloat, fillColor: UIColor, beginAlpha: CGFloat) {
            self.beginFrame = beginFrame
            self.increment = increment
            self.fillColor = fillColor
            self.beginAlpha = beginAlpha
            super.init(frame: beginFrame.inset(by: UIEdgeInsets(-increment)))
            self.backgroundColor = .clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let currnetIncrement = increment * progress
            let drawRect = beginFrame.inset(by: UIEdgeInsets(-currnetIncrement))
            let ctx = UIGraphicsGetCurrentContext()
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: min(drawRect.width, drawRect.height) * 0.5).cgPath
            ctx?.addPath(path)
            ctx?.setFillColor(fillColor.withAlphaComponent((1 - progress) * beginAlpha).cgColor)
            ctx?.fillPath()
        }
    }
}

extension RectRadarAnimationView {
    
    fileprivate class RadarScheduler {
        
        static let manager = RadarScheduler()
        
        typealias Handle = () -> Void
        
        class Item {
            
            weak var target: NSObjectProtocol?
            var handle: Handle?
            
            init(target: NSObjectProtocol?, handle: Handle?) {
                self.target = target
                self.handle = handle
            }
        }
        
        init() {
            timer = Timer(fireAt: Date.distantFuture, interval: 1, target: self, selector: #selector(RectRadarAnimationView.RadarScheduler.timerScheduled), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        }
        
        func remove(for identifier: AnyHashable) {
            values.removeValue(forKey: identifier)
            if values.count == 0 {
                timer.fireDate = Date.distantFuture
                print(">>> radar timer paused")
            }
        }
        
        func add(target: NSObjectProtocol, identifier: AnyHashable, _ handle: @escaping Handle) {
            values[identifier] = Item(target: target, handle: handle)
            if timer.isValid {
                timer.fireDate = Date()
                print(">>> radar timer fired")
            }
        }
        
        var values = [AnyHashable : Item]()
        var timer: Timer!
        
        @objc
        func timerScheduled() {
            values = values.filter { $0.value.target != nil }
            values.forEach { $0.value.handle?() }
        }
    }
    
    fileprivate class AnimateScheduler {
        
        static let manager = AnimateScheduler()
        
        typealias Handle = () -> Void
        
        class Item {
            
            weak var target: NSObjectProtocol?
            var handle: Handle?
            
            init(target: NSObjectProtocol?, handle: Handle?) {
                self.target = target
                self.handle = handle
            }
        }
        
        init() {
            timer = Timer(fireAt: Date.distantFuture, interval: 0.02, target: self, selector: #selector(RectRadarAnimationView.AnimateScheduler.timerScheduled), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        }
        
        func remove(for identifier: AnyHashable) {
            values.removeValue(forKey: identifier)
            if values.count == 0 {
                timer.fireDate = Date.distantFuture
                print(">>> radar animate timer paused")
            }
        }
        
        func add(target: NSObjectProtocol, identifier: AnyHashable, _ handle: @escaping Handle) {
            values[identifier] = Item(target: target, handle: handle)
            if timer.isValid {
                timer.fireDate = Date()
                print(">>> radar animate timer fired")
            }
        }
        
        var values = [AnyHashable : Item]()
        var timer: Timer!
        
        @objc
        func timerScheduled() {
            values = values.filter { $0.value.target != nil }
            values.forEach { $0.value.handle?() }
        }
    }
}

