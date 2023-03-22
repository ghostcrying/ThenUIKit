//
//  UIVIew++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: ViewableType {
    
    /// Get The Color Of View's Point
    func color(at point: CGPoint) -> UIColor? {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        defer { pixel.deallocate() }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.translateBy(x: -point.x, y: -point.y)
        base.layer.render(in: context)
        return .init(Int(pixel[0]), Int(pixel[1]), Int(pixel[2]), Int(pixel[3]))
    }
}
