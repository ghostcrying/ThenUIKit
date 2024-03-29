//
//  UIScreen+Brightness.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import ObjectiveC.runtime
import ThenFoundation
import UIKit

public extension ThenExtension where T: UIScreen {
    var scale: CGFloat {
        return scale(with: 667.0)
    }

    func scale(with target: CGFloat) -> CGFloat {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            return value.bounds.width / target
        } else {
            return value.bounds.height / target
        }
    }
}

public extension ThenExtension where T: UIScreen {
    @discardableResult
    func brightnessFade(to brightness: CGFloat, in timeInterval: TimeInterval = 0.5) -> ThenExtension {
        value.brightness_fade(to: brightness, in: timeInterval)
        return self
    }
}

// MARK: UIScreen brightness fade

private extension UIScreen {
    // 在timeInterval时间内把亮度调装为brightness
    func brightness_fade(to brightness: CGFloat, in timeInterval: TimeInterval = 0.5) {
        // 差值
        let distance = brightness - self.brightness
        // 相同，不需要调整
        if distance == 0 {
            return
        }
        // 得到displayLink
        guard let link = displayLink(withTarget: self, selector: #selector(brightness_linkAction(_:))) else {
            return
        }
        // 得到刷新帧率，默认60
        var framesPerSecond = 60
        if #available(iOS 10.0, *) {
            framesPerSecond = link.preferredFramesPerSecond
        }
        // 如果小于30，则固定为30
        if framesPerSecond < 30 {
            framesPerSecond = 30
        }
        // 周期如果小于0，则固定为默认
        let timeInt = timeInterval > 0 ? timeInterval : UIScreen.brightnessDefaultTimeInt
        let step = distance / (CGFloat(framesPerSecond) * CGFloat(timeInt))
        // 每次修改值如果为0，则结束
        if step == 0 {
            return
        }

        // 如果存在未完成的link，则移除掉
        if let current_link = objc_getAssociatedObject(self, ScreenBrightnessKey.link) as? CADisplayLink {
            brightness_removeLink(current_link)
        }

        // 绑定link
        objc_setAssociatedObject(self, ScreenBrightnessKey.link, link, .OBJC_ASSOCIATION_RETAIN)

        // 将最终亮度值和每次修改的亮度值绑定到link上
        objc_setAssociatedObject(link, ScreenBrightnessKey.ends, brightness, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(link, ScreenBrightnessKey.step, step, .OBJC_ASSOCIATION_COPY_NONATOMIC)

        // 将link添加进current RunLoop
        link.add(to: RunLoop.current, forMode: .common)
    }

    // 默认周期
    private static let brightnessDefaultTimeInt: TimeInterval = 0.5

    private func brightness_removeLink(_ link: CADisplayLink) {
        // 解除绑定
        objc_setAssociatedObject(self, ScreenBrightnessKey.link, nil, .OBJC_ASSOCIATION_RETAIN)
        link.invalidate()
    }

    // displayLink 的回调
    @objc
    private func brightness_linkAction(_ link: CADisplayLink) {
        // 取出 最终亮度值 和 每次修改的亮度值，未正确取出则结束
        guard
            let ness = objc_getAssociatedObject(link, ScreenBrightnessKey.ends) as? CGFloat,
            let step = objc_getAssociatedObject(link, ScreenBrightnessKey.step) as? CGFloat
        else {
            brightness_removeLink(link)
            return
        }
        // 亮度值加过或减过最终值，则结束
        if (step >= 0 && brightness >= ness) || (step <= 0 && brightness <= ness) {
            brightness_removeLink(link)
            return
        }
        // 继续增加或减少亮度值
        brightness += step
    }
}

private enum ScreenBrightnessKey {
    @UniqueAddress static var link
    /// 每次修改的亮度值
    @UniqueAddress static var step
    /// 最终亮度值
    @UniqueAddress static var ends
}
