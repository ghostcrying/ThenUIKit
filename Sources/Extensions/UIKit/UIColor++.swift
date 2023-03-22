//
//  UIColor++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/15.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIColor {
    
    static func hex(_ value: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(hex: value, alpha: alpha)
    }
    
    /// 反色 (F0F0F0 -> 0F0F0F)
    func inverted(_ alpha: CGFloat? = nil) -> UIColor? {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        guard base.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: alpha ?? (1 - a))
    }
    
    /// 按百分比减淡颜色值 (000000 -> 111111)
    func burn(_ percent: CGFloat, _ alpha: CGFloat? = nil) -> UIColor? {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        guard base.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return UIColor(red: r * (1 - percent), green: g * (1 - percent), blue: b * (1 - percent), alpha: alpha ?? a)
    }
    
    /// 按百分比加深颜色值 (FFFFFF -> EEEEEE)
    func dodge(_ percent: CGFloat, _ alpha: CGFloat? = nil) -> UIColor? {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        guard base.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return UIColor(red: r * (1 + percent), green: g * (1 + percent), blue: b * (1 + percent), alpha: alpha ?? a)
    }
    
    
    var components: [CGFloat]? {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        guard base.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return [r, g, b, a]
    }
    
    var red: CGFloat? {
        var r: CGFloat = 0
        guard base.getRed(&r, green: nil, blue: nil, alpha: nil) else { return nil }
        return r
    }
    
    var green: CGFloat? {
        var g: CGFloat = 0
        guard base.getRed(nil, green: &g, blue: nil, alpha: nil) else { return nil }
        return g
    }
    
    var blue: CGFloat? {
        var b: CGFloat = 0
        guard base.getRed(nil, green: nil, blue: &b, alpha: nil) else { return nil }
        return b
    }
    
    var alpha: CGFloat? {
        var a: CGFloat = 0
        guard base.getRed(nil, green: nil, blue: nil, alpha: &a) else { return nil }
        return a
    }
    
}

public extension UIColor {
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) {
        self.init(red: CGFloat(abs(red % 0x100)) / 255.0,
                  green: CGFloat(abs(green % 0x100)) / 255.0,
                  blue: CGFloat(abs(blue % 0x100)) / 255.0,
                  alpha: CGFloat(abs(alpha % 0x100)) / 255.0)
    }
    
    convenience init(hex value: Int, alpha: CGFloat = 1) {
        let red   = CGFloat((value >> 16) & 0xff) / 255.0
        let green = CGFloat((value >> 8) & 0xff) / 255.0
        let blue  = CGFloat(value & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Grandient Colors Directions
    enum GradientDirection {
        case horizatal          // 水平渐变
        case vertical           // 垂直渐变
        case downDiagonalLine   // 向上对角线渐变
        case upwardDiagonalLine // 向下对角线渐变
        
        ///
        internal var endedPoint: CGPoint {
            switch self {
            case .vertical:
                return .init(x: 0, y: 1)
            case .downDiagonalLine:
                return .init(x: 1, y: 1)
            case .upwardDiagonalLine:
                return .init(x: 1, y: 0)
            default:
                return .init(x: 1, y: 0)
            }
        }
    }

    /// Grandient Colors Func
    static func grandientColor(size: CGSize, direction: GradientDirection, colors: [UIColor]) -> UIColor {
        let count = colors.count
        guard count != 0 else {
            return UIColor.white
        }
        guard count != 1 else {
            return colors[0]
        }
        guard size != CGSize.zero else {
            return UIColor.white
        }
        
        let startPoint: CGPoint = direction == .upwardDiagonalLine ? .zero : .init(x: 0, y: 1)
        let endedPoint: CGPoint = direction.endedPoint
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endedPoint
        gradientLayer.colors = colors.compactMap({ $0.cgColor })
        
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIColor.white
        }
        gradientLayer.render(in: context)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return UIColor(patternImage: image)
        }
        return UIColor.white
    }
    
    
    /// The color for text labels that contain primary content.
    class var labelColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
}


