//
//  UIImage++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIImage {
    
    /// 某个像素点的颜色值
    func color(at point: CGPoint) -> UIColor? {
        return color(in: CGRect(x: point.x, y: point.y, width: 1, height: 1))
    }
    
    /// 某块像素点的平均颜色值
    func color(in rect: CGRect) -> UIColor? {
        let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        guard
            bounds.intersects(rect),
            let cgimage = base.cgImage,
            let dataProvider = cgimage.dataProvider,
            let data = dataProvider.data,
            let pointer = CFDataGetBytePtr(data)
        else {
            return nil
        }
        
        let comptsPerPixel = cgimage.bitsPerPixel / cgimage.bitsPerComponent
        
        let image_w = Int(base.size.width)
        
        let interRect = bounds.intersection(rect)
        
        let inter_x = Int(interRect.minX)
        let inter_y = Int(interRect.minY)
        let inter_w = Int(interRect.width)
        let inter_h = Int(interRect.height)
        
        var r: Int = 0
        var g: Int = 0
        var b: Int = 0
        var a: Int = 0
        
        for y in 0..<inter_h {
            for x in 0..<inter_w {
                let index = (image_w * (inter_y + y) + (inter_x + x)) * comptsPerPixel
                r += Int(pointer.advanced(by: index + 0).pointee)
                g += Int(pointer.advanced(by: index + 1).pointee)
                b += Int(pointer.advanced(by: index + 2).pointee)
                a += Int(pointer.advanced(by: index + 3).pointee)
            }
        }
        
        let pixelCount = inter_w * inter_h
        
        let red     = (CGFloat(r) / CGFloat(pixelCount)) / 255.0
        let green   = (CGFloat(g) / CGFloat(pixelCount)) / 255.0
        let blue    = (CGFloat(b) / CGFloat(pixelCount)) / 255.0
        let alpha   = (CGFloat(a) / CGFloat(pixelCount)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 图片二维码识别
    var qrCodes: [String] {
        
        guard let ciImage = CIImage(image: base) else { return [] }
        let context = CIContext()
        var options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
            options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        } else {
            options = [CIDetectorImageOrientation: 1]
        }
        guard let features = qrDetector?.features(in: ciImage, options: options) else {
            return []
        }
        return features.compactMap {
            guard let text = ($0 as? CIQRCodeFeature)?.messageString else { return nil }
            return text.isEmpty ? nil : text
        }
    }
    
    /// Size in bytes of UIImage
    var bytesSize: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }
}

public extension ThenExtension where T: UIImage {
    
    ///  UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        return base.cropped(to: rect)
    }
    
    ///  UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        return base.scaled(toHeight: toHeight, opaque: opaque)
    }
    
    ///  UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        return base.scaled(toWidth: toWidth, opaque: opaque)
    }
    
    ///  Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        return base.rotated(by: angle)
    }
    
    ///  Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        return base.rotated(by: radians)
    }
    
    ///  UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - byRoundingCorners: corner positions
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func roundCorners(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, radius: CGFloat? = nil) -> UIImage? {
        return base.roundCorners(byRoundingCorners: byRoundingCorners, radius: radius)
    }
    
    /// UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage? {
        return base.tint(color, blendMode: blendMode)
    }
    
    
    /// UIImage Circle Clip in Center
    func circleClip() -> UIImage? {
        return base.circleClip()
    }
    
    
    /// save to album
    @discardableResult
    func albumSave() -> ThenExtension {
        base.albumSave()
        return self
    }

    /// device gray
    func deviceGray() -> UIImage? {
        return base.deviceGray()
    }
}

//MARK: - Convenience init
public extension UIImage {
    
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: aCgImage)
    }
    
    
    /// Save to album
    func albumSave() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    
    /// Circle Clip
    func circleClip() -> UIImage? {
        // 取最短边长
        let shotest = min(size.width, size.height)
        // 输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        
        // 开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        // 添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        
        // 绘制图片
        draw(in: CGRect(x: (shotest - size.width)/2, y: (shotest - size.height)/2, width: size.width, height: size.height))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width && rect.size.height <= size.height else {
            return self
        }
        guard let image: CGImage = cgImage?.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: image)
    }
    
    ///  UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)
        
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        defer { UIGraphicsEndImageContext() }
        
        guard let contextRef = UIGraphicsGetCurrentContext() else {
            return nil
        }
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        defer { UIGraphicsEndImageContext() }
        
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    ///  UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - byRoundingCorners: corner positions
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func roundCorners(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).addClip()
        draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage? {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// DeviceGray Space Image
    func deviceGray() -> UIImage? {
        let w = Int(size.width)
        let h = Int(size.height)
        let spaceRef = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        /// 参数1：指向要渲染的绘制内存的地址，
        /// 参数2，3：高度和宽度，
        /// 参数4：表示内存中像素的每个组件的位数，
        /// 参数5：每一行在内存所占的比特数
        /// 参数6：表示上下文使用的颜色空间，
        /// 参数7：表示是否包含透明通道
        guard let context = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: spaceRef, bitmapInfo: bitmapInfo),
              let cgImage = self.cgImage else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.draw(cgImage, in: rect)
        guard let makeImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: makeImage)
    }
}
