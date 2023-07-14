//
//  UIView+Draw.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/17.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIView {
    
    /// 绘制线条
    @discardableResult
    func drawline(points: [CGPoint], lineWidth: CGFloat, lineColor: UIColor) -> ThenExtension {
        value.drawline(points: points, lineWidth: lineWidth, lineColor: lineColor)
        return self
    }
    
    /// 绘制虚线
    @discardableResult
    func drawDashline(points: [CGPoint], lineWidth: CGFloat, lineColor: UIColor) -> ThenExtension {
        value.drawDashline(points: points, lineWidth: lineWidth, lineColor: lineColor)
        return self
    }
    
    /// 绘制矩形
    @discardableResult
    func drawRectAngle(rect: CGRect, color: UIColor) -> ThenExtension {
        value.drawRectAngle(rect: rect, color: color)
        return self
    }
    
    /// 绘制图片
    @discardableResult
    func drawImage(name: String? = nil, rect: CGRect) -> ThenExtension {
        value.drawImage(name: name, rect: rect)
        return self
    }
    
    /// 渐变边框
    @discardableResult
    func gradientBorder(direction: UIView.GradientDirection = .horizontal, radius: CGFloat, lineWidth: CGFloat, colors: [UIColor]) -> ThenExtension {
        value.gradientBorder(direction:direction, radius: radius, lineWidth: lineWidth, colors: colors)
        return self
    }
    
    /// 渐变背景
    @discardableResult
    func gradientBackground(direction: UIView.GradientDirection = .horizontal, colors: [UIColor]) -> ThenExtension {
        value.gradientBackground(direction: direction, colors: colors)
        return self
    }
}

public extension UIView {
    
    /// 绘制折线
    /// - Parameters:
    ///   - points: 点
    ///   - width: 折线宽度
    ///   - color: 折线颜色
    func drawline(points: [CGPoint], lineWidth: CGFloat, lineColor: UIColor) {
        guard points.count > 1 else { return }
        let linePath = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        linePath.stroke()
    }
    
    /// 绘制虚线
    /// - Parameters:
    ///   - points: 组成虚线段的点
    ///   - width: 线宽
    ///   - color: 线的颜色
    func drawDashline(points: [CGPoint], lineWidth: CGFloat, lineColor: UIColor) {
        guard points.count > 1 else { return }
        let path = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.lineWidth = lineWidth
        path.setLineDash([4, 4], count: 1, phase: 0)
        lineColor.setStroke()
        path.stroke()
    }
    
    
    /// 绘制矩形
    /// - Parameters:
    ///   - rect: 矩形位置以及大小
    ///   - color: 颜色
    func drawRectAngle(rect: CGRect, color: UIColor = UIColor(hex: 0xDBE0ED)) {
        let path = UIBezierPath(rect: rect)
        color.setFill()
        path.fill()
    }
    
    
    /// 绘制图片
    /// - Parameters:
    ///   - name: 图片名称
    ///   - rect: 图片位置以及大小
    func drawImage(name: String? = nil, rect: CGRect) {
        guard let imageName = name else { return }
        guard let image = UIImage(named: imageName) else { return }
        image.draw(in: rect)
    }
    
    
    /// 渐变边框
    func gradientBorder(direction: GradientDirection = .horizontal, radius: CGFloat, lineWidth: CGFloat, colors: [UIColor]) {
        
        let path = UIBezierPath(roundedRect: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: bounds.width - lineWidth, height: bounds.height - lineWidth), cornerRadius: radius)
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        if direction == .vertical {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        gradient.colors = colors.map { $0.cgColor }
        gradient.cornerRadius = radius
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
    
    
    /// 渐变背景
    func gradientBackground(direction: GradientDirection = .horizontal, colors: [UIColor]) {
        guard bounds != .zero else { return }
        let gradientLayer = CAGradientLayer()
        //几个颜色
        gradientLayer.colors = colors.map { $0.cgColor }
        //颜色的分界点
        gradientLayer.locations = [0, 1.0]
        if direction == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        // 多大区域
        gradientLayer.frame = bounds
        
        if self is UIButton {
            let button = self as! UIButton
            layer.insertSublayer(gradientLayer, below: button.titleLabel?.layer)
        } else {
            layer.addSublayer(gradientLayer)
        }
    }
    
}


public extension UIView {
    /// 渐变方向
    enum GradientDirection: Int {
        case vertical = 0
        case horizontal = 1
    }
}
