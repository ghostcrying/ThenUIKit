//
//  UIVIew+Animate.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/28.
//

import UIKit
import ThenFoundation

/// Animation protocol defines the initial transform for a view for it to
/// animate to its identity position.
public protocol ThenAnimationType {
    
    /// Defines the starting point for the animations.
    var initialTransform: CGAffineTransform { get }
}

public extension UIView {
    
    // MARK: - Single View
    
    /// UIView.animateWithDuration API
    /// - Parameters:
    ///   - animations: 动画组
    ///   - reversed: 动画的初始状态。反向动画将从其原始位置开始。
    ///   - initialAlpha: 动画之前视图的初始透明度。
    ///   - finalAlpha: 动画之后视图的透明度。
    ///   - delay: 动画之前的延迟时间。
    ///   - duration: 动画持续时间
    ///   - options: UIView.AnimationsOptions to pass to the animation block.
    ///   - completion: block to run  after the animation finishes.
    @inlinable func animate(
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        let transformFrom = transform
        var transformTo = transform
        animations.forEach { transformTo = transformTo.concatenating($0.initialTransform) }
        if !reversed {
            transform = transformTo
        }
        
        alpha = initialAlpha
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: { [weak self] in
            self?.transform = reversed ? transformTo : transformFrom
            self?.alpha = finalAlpha
        }) { _ in
            completion?()
        }
    }
    
    /// Animation based on UIView.animateWithDuration using springs
    ///
    /// - Parameters:
    ///   - animations: 动画组
    ///   - reversed: 动画的初始状态。反向动画将从其原始位置开始。
    ///   - initialAlpha: 动画之前视图的初始透明度。
    ///   - finalAlpha: 动画之后视图的透明度。
    ///   - delay: 动画之前的延迟时间。
    ///   - duration: 东海持续时间
    ///   - dampingRatio: 弹簧动画的阻尼比。
    ///   - velocity: 初始弹簧速度。
    ///   - options: UIView.AnimationsOptions to pass to the animation block. Timing functions will have no impact on spring based animations.
    ///   - completion: CompletionBlock after the animation finishes.
    @inlinable func animate(
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        duration: TimeInterval = 0.3,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        let transformFrom = transform
        var transformTo = transform
        animations.forEach { transformTo = transformTo.concatenating($0.initialTransform) }
        if !reversed {
            transform = transformTo
        }
        
        alpha = initialAlpha
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: velocity,
                       options: options,
                       animations: { [weak self] in
            self?.transform = reversed ? transformTo : transformFrom
            self?.alpha = finalAlpha
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - UIView Array
    
    /// Animates multiples views with cascading effect using the UIView.animateWithDuration API
    ///
    /// - Parameters:
    ///   - animations: Array of Animations to perform on the animation block.
    ///   - reversed: Initial state of the animation. Reversed will start from its original position.
    ///   - initialAlpha: Initial alpha of the view prior to the animation.
    ///   - finalAlpha: View's alpha after the animation.
    ///   - delay: Time Delay before the animation.
    ///   - animationInterval: Interval between the animations of each view.
    ///   - duration: TimeInterval the animation takes to complete.
    ///   - dampingRatio: The damping ratio for the spring animation.
    ///   - velocity: The initial spring velocity.
    ///   - options: UIView.AnimationsOptions to pass to the animation block. Timing functions will have no impact on spring based animations.
    ///   - completion: CompletionBlock after the animation finishes.
    static func animate(
        views: [UIView],
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        animationInterval: TimeInterval = 0.05,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        performAnimation(views: views, animations: animations, reversed: reversed, initialAlpha: initialAlpha, delay: delay, animationBlock: { view, index, dispatchGroup in
            view.animate(animations: animations,
                         reversed: reversed,
                         initialAlpha: initialAlpha,
                         finalAlpha: finalAlpha,
                         delay: Double(index) * animationInterval,
                         duration: duration,
                         options: options,
                         completion: { dispatchGroup.leave() })
        }, completion: completion)
    }
    
    /// Animates multiples views with cascading effect using the UIView.animateWithDuration with springs
    ///
    /// - Parameters:
    ///   - animations: Array of Animations to perform on the animation block.
    ///   - reversed: Initial state of the animation. Reversed will start from its original position.
    ///   - initialAlpha: Initial alpha of the view prior to the animation.
    ///   - finalAlpha: View's alpha after the animation.
    ///   - delay: Time Delay before the animation.
    ///   - animationInterval: Interval between the animations of each view.
    ///   - duration: TimeInterval the animation takes to complete.
    ///   - dampingRatio: The damping ratio for the spring animation.
    ///   - velocity: The initial spring velocity.
    ///   - options: UIView.AnimationsOptions to pass to the animation block. Timing functions will have no impact on spring based animations.
    ///   - completion: CompletionBlock after the animation finishes.
    static func animate(
        views: [UIView],
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        animationInterval: TimeInterval = 0.05,
        duration: TimeInterval = 0.3,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        performAnimation(views: views, animations: animations, reversed: reversed, initialAlpha: initialAlpha, delay: delay, animationBlock: { view, index, dispatchGroup in
            view.animate(animations: animations,
                         reversed: reversed,
                         initialAlpha: initialAlpha,
                         finalAlpha: finalAlpha,
                         delay: Double(index) * animationInterval,
                         duration: duration,
                         usingSpringWithDamping: dampingRatio,
                         initialSpringVelocity: velocity,
                         options: options,
                         completion: { dispatchGroup.leave() })
        }, completion: completion)
    }
    
    /// 用于在多个 UIView 实例之间执行动画, 指定动画序列
    static private func performAnimation(
        views: [UIView],
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        delay: Double = 0,
        animationBlock: @escaping ((UIView, Int, DispatchGroup) -> ()),
        completion: (() -> ())? = nil)
    {
        guard !views.isEmpty else {
            completion?()
            return
        }
        
        views.forEach { $0.alpha = initialAlpha }
        let dispatchGroup = DispatchGroup()
        for _ in 1...views.count { dispatchGroup.enter() }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            for (index, view) in views.enumerated() {
                animationBlock(view, index, dispatchGroup)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
}

public extension Array where Element == UIView {
    
    /// Animates multiples views with cascading effect using the UIView.animateWithDuration API
    ///
    /// - Parameters:
    ///   - animations: Array of Animations to perform on the animation block.
    ///   - reversed: Initial state of the animation. Reversed will start from its original position.
    ///   - initialAlpha: Initial alpha of the view prior to the animation.
    ///   - finalAlpha: View's alpha after the animation.
    ///   - delay: Time Delay before the animation.
    ///   - animationInterval: Interval between the animations of each view.
    ///   - duration: TimeInterval the animation takes to complete.
    ///   - dampingRatio: The damping ratio for the spring animation.
    ///   - velocity: The initial spring velocity.
    ///   - options: UIView.AnimationsOptions to pass to the animation block. Timing functions will have no impact on spring based animations.
    ///   - completion: CompletionBlock after the animation finishes.
    func animate(
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        animationInterval: TimeInterval = 0.05,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        performAnimation(animations: animations, reversed: reversed, initialAlpha: initialAlpha, delay: delay, animationBlock: { view, index, dispatchGroup in
            view.animate(animations: animations,
                         reversed: reversed,
                         initialAlpha: initialAlpha,
                         finalAlpha: finalAlpha,
                         delay: Double(index) * animationInterval,
                         duration: duration,
                         options: options,
                         completion: { dispatchGroup.leave() })
        }, completion: completion)
    }
    
    /// Animates multiples views with cascading effect using the UIView.animateWithDuration with springs
    ///
    /// - Parameters:
    ///   - animations: Array of Animations to perform on the animation block.
    ///   - reversed: Initial state of the animation. Reversed will start from its original position.
    ///   - initialAlpha: Initial alpha of the view prior to the animation.
    ///   - finalAlpha: View's alpha after the animation.
    ///   - delay: Time Delay before the animation.
    ///   - animationInterval: Interval between the animations of each view.
    ///   - duration: TimeInterval the animation takes to complete.
    ///   - dampingRatio: The damping ratio for the spring animation.
    ///   - velocity: The initial spring velocity.
    ///   - options: UIView.AnimationsOptions to pass to the animation block. Timing functions will have no impact on spring based animations.
    ///   - completion: CompletionBlock after the animation finishes.
    func animate(
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        finalAlpha: CGFloat = 1.0,
        delay: Double = 0,
        animationInterval: TimeInterval = 0.05,
        duration: TimeInterval = 0.3,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions = [],
        completion: (() -> ())? = nil)
    {
        performAnimation(animations: animations, reversed: reversed, initialAlpha: initialAlpha, delay: delay, animationBlock: { view, index, dispatchGroup in
            view.animate(animations: animations,
                         reversed: reversed,
                         initialAlpha: initialAlpha,
                         finalAlpha: finalAlpha,
                         delay: Double(index) * animationInterval,
                         duration: duration,
                         usingSpringWithDamping: dampingRatio,
                         initialSpringVelocity: velocity,
                         options: options,
                         completion: { dispatchGroup.leave() })
        }, completion: completion)
    }
    
    /// 用于在多个 UIView 实例之间执行动画, 指定动画序列
    private func performAnimation(
        animations: [ThenAnimationType],
        reversed: Bool = false,
        initialAlpha: CGFloat = 0.0,
        delay: Double = 0,
        animationBlock: @escaping ((UIView, Int, DispatchGroup) -> ()),
        completion: (() -> ())? = nil)
    {
        guard !isEmpty else {
            completion?()
            return
        }
        
        forEach { $0.alpha = initialAlpha }
        let dispatchGroup = DispatchGroup()
        (1...count).forEach { _ in dispatchGroup.enter() }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            for (index, view) in enumerated() {
                animationBlock(view, index, dispatchGroup)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
}
