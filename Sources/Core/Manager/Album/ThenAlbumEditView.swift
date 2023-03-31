//
//  ThenAlbumEditView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/1.
//

import UIKit

class ThenAlbumEditView: UIView {

    enum PickerType {
        case cancel
        case sure(UIImage?)
    }
    
    //MARK: - views
    private lazy var contentView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.addSubview(self.scrollview)
        return view
    }()
    
    private lazy var sure: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: w - 6 - 80, y: h - bottom - 49, width: 80, height: 49)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancel: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 6, y: h - bottom - 49, width: 80, height: 49)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollview: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.delegate = self
        scroll.backgroundColor = UIColor.black
        return scroll
    }()
    
    private var imageView: UIImageView?
    
    
    //MARK: - properties
    var clickClosure: ((PickerType) -> ())?
    
    //
    private var bottom: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    private var clipWidth: CGFloat {
        return UIScreen.main.bounds.size.width - 64
    }
    
    private let clipline: CGFloat = 1
    
    private let maxScale: CGFloat = 3.0
    private let minScale: CGFloat = 1.0
    
    private let w = UIScreen.main.bounds.size.width
    private let h = UIScreen.main.bounds.size.height
    
    private var style: ThenAlbumPicker.ClipStyle = .square {
        didSet {
            initClip()
            addSubview(cancel)
            addSubview(sure)
        }
    }
     
    //MARK: - Lifecycle
    required convenience init(frame: CGRect, style: ThenAlbumPicker.ClipStyle) {
        self.init(frame: frame)
        self.style = style
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.black

        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // 裁剪区域
    private func initClip() {
        // 获取上下文 size表示图片大小 false表示透明 0表示自动适配屏幕大小
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
        context?.fill(UIScreen.main.bounds)
        context?.addArc(center: CGPoint(x: w/2, y: h/2), radius: clipWidth/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        context?.setBlendMode(.clear)
        context?.fillPath()

        // 绘制框框
        context?.setBlendMode(.color)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(clipline)
        context?.strokeEllipse(in: CGRect(x: (w - clipWidth) / 2, y: (h - clipWidth) / 2, width: clipWidth, height: clipWidth))
        context?.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let clipView = UIImageView(image: image)
        clipView.frame.origin = CGPoint(x: 0, y: 0)
        addSubview(clipView)
    }
    
}

//MARK: - Actions
extension ThenAlbumEditView {
    
    @objc func sureClick() {
        if style == .circle {
            if let image = self.contentView.clipCenterImage(clipWidth)?.circleClip() {
                self.clickClosure?(.sure(image))
            }
        } else {
            if let image = self.contentView.clipCenterImage(clipWidth) {
                self.clickClosure?(.sure(image))
            }
        }
        self.clickClosure?(.sure(nil))
    }
    
    @objc func cancelClick() {
        self.clickClosure?(.cancel)
    }
    
    // 刷新UI
    func configUI(_ image: UIImage) {
        
        self.imageView = UIImageView(image: image)
        self.imageView?.center = scrollview.center
        self.scrollview.addSubview(self.imageView!)
        
        if imageView!.bounds.width > w {
            imageView!.frame.size = CGSize(width: w, height: imageView!.bounds.height / imageView!.bounds.width * w)
            imageView!.center = scrollview.center
        } else if imageView!.bounds.height > h {
            imageView!.frame.size = CGSize(width: imageView!.bounds.size.width / imageView!.bounds.height * h, height: h)
            imageView!.center = scrollview.center
        }
        
        let size = imageView!.frame.size
        let veriPadding = CGFloat(abs((clipWidth - size.height) / 2))
        let horiPadding = CGFloat(abs((clipWidth - size.width) / 2))
        scrollview.contentSize  = CGSize(width: w + horiPadding * 2, height: h + veriPadding * 2)
        scrollview.contentInset = UIEdgeInsets(top: veriPadding, left: horiPadding, bottom: -veriPadding, right: -horiPadding)
        
        // 隐藏导航条
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        
        // 设置缩放属性
        scrollview.maximumZoomScale = maxScale
        scrollview.minimumZoomScale = minScale
    }
    
}

//MARK: - UIScrollViewDelegate
extension ThenAlbumEditView: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 当捏或移动时，需要对center重新定义以达到正确显示位置
        let centerX = (scrollView.contentSize.width > scrollView.frame.size.width) ? (scrollView.contentSize.width / 2) : scrollView.center.x
        let centerY = (scrollView.contentSize.height > scrollView.frame.size.height) ? (scrollView.contentSize.height / 2) : scrollView.center.y
        self.imageView?.center = CGPoint(x: centerX, y: centerY)
        
        guard let size = imageView?.frame.size else { return }
        
        let horiPadding = CGFloat(abs((min(size.width, w) - clipWidth) / 2))
        let veriPadding = CGFloat(abs((min(size.height, h) - clipWidth) / 2))
        scrollview.contentSize = CGSize(width: max(size.width, w) + horiPadding * 2, height: max(size.height, h) + veriPadding * 2)
        scrollview.contentInset = UIEdgeInsets(top: veriPadding, left: horiPadding, bottom: -veriPadding, right: -horiPadding)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

extension UIView {
    
    /// 裁剪圆形区域
    func clipCenterImage(_ clipWidth: CGFloat) -> UIImage? {
        
        let size  = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        guard let img = UIGraphicsGetImageFromCurrentImageContext()?.cgImage,
              let result = img.cropping(to: CGRect(x: (UIScreen.main.bounds.size.width - clipWidth) / 2 * scale, y: (UIScreen.main.bounds.size.height - clipWidth) / 2 * scale, width: clipWidth * scale, height: clipWidth * scale)) else {
                return nil
        }
        UIGraphicsEndImageContext()
        // 转换并裁剪
        return UIImage(cgImage: result, scale: scale, orientation: .up) // .circleClip()
    }
}
