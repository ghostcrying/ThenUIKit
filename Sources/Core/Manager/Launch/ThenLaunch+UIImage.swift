//
//  ThenLaunch+UIImage.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/25.
//

import UIKit

struct LaunchColor {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var a: CGFloat
    
    static func thresholdEqual(_ lhs: LaunchColor, _ rhs: LaunchColor, threshold: CGFloat = 0.2) -> Bool {
        abs(lhs.r - rhs.r) <= threshold &&
        abs(lhs.g - rhs.g) <= threshold &&
        abs(lhs.b - rhs.b) <= threshold &&
        abs(lhs.a - rhs.a) <= threshold
    }
}

extension UIImage {
    
    var launchOpaque: Bool {
        guard let info = self.cgImage?.alphaInfo else {
            return false
        }
        switch info {
        case .noneSkipLast, .noneSkipFirst, .none:
            return true
        default:
            return false
        }
    }
    
    var isPortrait: Bool { size.width < size.height }
        
}

extension UIImage {
        
    /// ll_drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode
    func launchFitDraw(in rect: CGRect, content mode: UIView.ContentMode) {
        /// ll_CGRectFitWithContentMode:(UIViewContentMode)mode size:(CGSize)size rect:(CGRect)rect
        func modeRect(with mode: UIView.ContentMode, size: CGSize, rect: CGRect) -> CGRect {
            var rect = rect.standardized
            var size = size
            size.width  = size.width  < 0 ? -size.width  : size.width
            size.height = size.height < 0 ? -size.height : size.height
            let center = CGPoint(x: rect.midX, y: rect.midY)
            
            switch mode {
            case .scaleAspectFit, .scaleAspectFill:
                if rect.size.width < 0.01 || rect.size.height < 0.01 || size.width < 0.01 || size.height < 0.01 {
                    rect.origin = center
                    rect.size = .zero
                } else {
                    var scale: CGFloat
                    if mode == .scaleAspectFit {
                        if size.width / size.height < rect.size.width / rect.size.height {
                            scale = rect.size.height / size.height
                        } else {
                            scale = rect.size.width / size.width
                        }
                    } else {
                        if size.width / size.height < rect.size.width / rect.size.height {
                            scale = rect.size.width / size.width
                        } else {
                            scale = rect.size.height / size.height
                        }
                    }
                    size.width *= scale
                    size.height *= scale
                    rect.size = size
                    rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
                }
            case .center:
                rect.size = size
                rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
            case .top:
                rect.origin.x = center.x - size.width * 0.5
                rect.size = size
            case .bottom:
                rect.origin.x = center.x - size.width * 0.5
                rect.origin.y += rect.size.height - size.height
                rect.size = size
            case .left:
                rect.origin.y = center.y - size.height * 0.5
                rect.size = size
            case .right:
                rect.origin.y = center.y - size.height * 0.5
                rect.origin.x += rect.size.width - size.width
                rect.size = size
            case .topLeft:
                rect.size = size
            case .topRight:
                rect.origin.x += rect.size.width - size.width
                rect.size = size
            case .bottomLeft:
                rect.origin.y += rect.size.height - size.height
                rect.size = size
            case .bottomRight:
                rect.origin.x += rect.size.width - size.width
                rect.origin.y += rect.size.height - size.height
                rect.size = size
            default:
                break
            }
            return rect
        }
        let rect = modeRect(with: mode, size: self.size, rect: rect)
        if rect.width == 0 || rect.height == 0 {
            return
        }
        draw(in: rect)
    }
    
    /// ll_imageByResizeToSize
    func launchResize(to size: CGSize, content mode: UIView.ContentMode) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, self.launchOpaque, self.scale)
        defer { UIGraphicsEndImageContext() }
        launchFitDraw(in: CGRect(origin: .zero, size: size), content: mode)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
        
    /// ll_isEqualToImage:(UIImage *)image ignoreAlpha:(BOOL)ignore threshold:(CGFloat)threshold
    func thresholdEqual(to image: UIImage, ignoreAlpha: Bool = false, threshold: CGFloat = 0.9) -> Bool {
        guard let ciImage1 = CIImage(image: self), let ciImage2 = CIImage(image: image) else { return false }
        guard !self.size.equalTo(.zero), !image.size.equalTo(.zero) else { return false }
        
        var image1 = self
        var image2 = image
        
        let size1 = image1.size
        let size2 = image2.size
        
        // 如果尺寸不一样，把大图调整成小图尺寸。
        if size1 != size2 {
            let isPortrait1 = image1.size.width < image1.size.height
            let isPortrait2 = image2.size.width < image2.size.height
            
            // 判断图片比例是否一样，如果1张是竖图，另1张是横图的话则直接返回。
            guard isPortrait1 == isPortrait2 else { return false }
            
            let scale1 = size1.width * size1.height
            let scale2 = size2.width * size2.height
            
            if scale1 > scale2 {
                image1 = self.scaled(to: 1.0)
                image2 = image.launchResize(to: size1, content: .scaleToFill) ?? image
            } else {
                image1 = self.launchResize(to: size2, content: .scaleToFill) ?? self
                image2 = image.scaled(to: 1.0)
            }
        }
                
        let context = CIContext()
        
        // 获取图片像素数据。
        let imageExtent = ciImage1.extent
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * Int(imageExtent.size.width)
        let totalBytes  = bytesPerRow * Int(imageExtent.size.height)
        
        let image1Data = UnsafeMutablePointer<UInt8>.allocate(capacity: totalBytes)
        let image2Data = UnsafeMutablePointer<UInt8>.allocate(capacity: totalBytes)
        
        context.render(ciImage1, toBitmap: image1Data, rowBytes: bytesPerRow, bounds: imageExtent, format: .RGBA8, colorSpace: nil)
        context.render(ciImage2, toBitmap: image2Data, rowBytes: bytesPerRow, bounds: imageExtent, format: .RGBA8, colorSpace: nil)
        
        // 计算两张图片的相似度。
        var ignoreCount = 0
        var samePixelCount = 0
        for i in stride(from: 0, to: totalBytes, by: bytesPerPixel) {
            let r1 = image1Data[i]
            let g1 = image1Data[i+1]
            let b1 = image1Data[i+2]
            let a1 = image1Data[i+3]
            
            let r2 = image2Data[i]
            let g2 = image2Data[i+1]
            let b2 = image2Data[i+2]
            let a2 = image2Data[i+3]
            
            if ignoreAlpha {
                // 忽略带透明的像素点。
                if a1 != 0xff || a2 != 0xff {
                    ignoreCount += 1
                    continue
                }
            }
            
            let color1 = LaunchColor(r: CGFloat(r1) / 255.0, g: CGFloat(g1) / 255.0, b: CGFloat(b1) / 255.0, a: CGFloat(a1) / 255.0)
            let color2 = LaunchColor(r: CGFloat(r2) / 255.0, g: CGFloat(g2) / 255.0, b: CGFloat(b2) / 255.0, a: CGFloat(a2) / 255.0)
            if LaunchColor.thresholdEqual(color1, color2, threshold: threshold) {
                samePixelCount += 1
            }
        }
        
        let similarity = CGFloat(samePixelCount) / (CGFloat(totalBytes) / CGFloat(bytesPerPixel) - CGFloat(ignoreCount))
        image1Data.deallocate()
        image2Data.deallocate()
        return (similarity >= threshold)
    }
    
}
