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
    
    // MARK: - views
    private lazy var contentView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollview)
        view.addSubview(clipView)
        view.addSubview(cancel)
        view.addSubview(sure)
        return view
    }()
    
    private lazy var sure: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancel: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollview: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.delegate = self
        scroll.backgroundColor = UIColor.black
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var clipView: ClipView = {
        let v = ClipView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.clear
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var imageView: UIImageView?
    
    // MARK: - properties
    private var clickClosure: ((PickerType) -> ())?
    
    private var bottom: CGFloat {
        return UIApplication.shared.window?.safeAreaInsets.bottom ?? 0
    }
    
    private var clipState: ThenAlbumPicker.ClipStyle = .square {
        didSet {
            clipView.clipState = clipState
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            clipView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            clipView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            clipView.topAnchor.constraint(equalTo: contentView.topAnchor),
            clipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cancel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 6),
            cancel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottom),
            cancel.widthAnchor.constraint(equalToConstant: 60),
            cancel.heightAnchor.constraint(equalToConstant: 49),
            
            sure.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            sure.bottomAnchor.constraint(equalTo: cancel.bottomAnchor),
            sure.widthAnchor.constraint(equalToConstant: 60),
            sure.heightAnchor.constraint(equalToConstant: 49),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipView.setNeedsDisplay()
        self.scrollview.frame = bounds
        
        guard let imageSize = self.imageView?.image?.size else {
            return
        }
        let clipWidth = min(bounds.width, bounds.height)
        let vertRatio = clipWidth / imageSize.height
        let horiRatio = clipWidth / imageSize.width
        
        self.scrollview.minimumZoomScale = max(horiRatio, vertRatio)
        self.scrollview.maximumZoomScale = 1
        self.scrollview.zoomScale = scrollview.minimumZoomScale
        
        let vertInset = bounds.height / 2 - clipWidth / 2 // 227
        let horiInset = bounds.width / 2 - clipWidth / 2   // 0.0
        self.scrollview.contentInset = UIEdgeInsets(top: vertInset, left: horiInset, bottom: vertInset, right: horiInset)
        
        // print("contentSize: \(self.scrollview.contentSize) contentOffset: \(self.scrollview.contentOffset) vertInset: \(vertInset) horiInset: \(horiInset)")
        
        // hori origin offset
        let x = (scrollview.contentSize.width - clipWidth) / 2 - horiInset
        if self.scrollview.contentOffset.x != x {
            self.scrollview.contentOffset = .init(x: x, y: self.scrollview.contentOffset.y)
        }
        // vert origin offset
        let y = (self.scrollview.contentSize.height - clipWidth) / 2 - vertInset
        if self.scrollview.contentOffset.y != y {
            self.scrollview.contentOffset = .init(x: self.scrollview.contentOffset.x, y: y)
        }
    }
}

// MARK: - Actions
extension ThenAlbumEditView {
    
    @objc func sureClick() {
        /// clip rect
        let clipWidth = min(bounds.width, bounds.height)
        let clipRects = CGRect(x: (bounds.width - clipWidth) / 2, y: (bounds.height - clipWidth) / 2, width: clipWidth, height: clipWidth)
        /// scale
        let offsetRect = clipRects.applying(CGAffineTransform(translationX: scrollview.contentOffset.x, y: scrollview.contentOffset.y))
        let scalesRect = offsetRect.applying(CGAffineTransform(scaleX: 1.0 / scrollview.zoomScale, y: 1.0 / scrollview.zoomScale))
        
        if clipState == .circle {
            if let image = imageView?.image?.cropping(to: scalesRect)?.circleClip() {
                self.clickClosure?(.sure(image))
            } else {
                self.clickClosure?(.sure(nil))
            }
        } else {
            if let image = imageView?.image?.cropping(to: scalesRect) {
                self.clickClosure?(.sure(image))
            } else {
                self.clickClosure?(.sure(nil))
            }
        }
    }
    
    @objc func cancelClick() {
        self.clickClosure?(.cancel)
    }
    
    // 刷新UI
    func configUI(image: UIImage, clipState: ThenAlbumPicker.ClipStyle, clickClosure: @escaping (PickerType) -> ()) {
        
        self.clickClosure = clickClosure
        
        self.imageView = UIImageView(image: image)
        self.scrollview.addSubview(self.imageView!)
        
        self.scrollview.frame = bounds
        self.scrollview.contentSize = image.size
        
        self.clipState = clipState
    }
    
}

// MARK: - UIScrollViewDelegate
extension ThenAlbumEditView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}

// MARK: - ClipView
extension ThenAlbumEditView {
    
    class ClipView: UIView {
        
        override var frame: CGRect {
            didSet {
                self.setNeedsDisplay()
            }
        }
        
        var clipState: ThenAlbumPicker.ClipStyle = .square {
            didSet {
                setNeedsDisplay()
            }
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.setFillColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
            context.fill(UIScreen.main.bounds)
            
            let minSpace = min(rect.width, rect.height)
            let hole = CGRect(x: (rect.width - minSpace) / 2, y: (rect.height - minSpace) / 2, width: minSpace, height: minSpace)
            if clipState == .square {
                context.addRect(hole)
            } else {
                context.addArc(center: center, radius: hole.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            }
            
            context.setBlendMode(.clear)
            context.fillPath()
            
            // border
            context.setBlendMode(.color)
            context.setStrokeColor(UIColor.white.cgColor)
            if clipState == .square {
                context.stroke(hole)
            } else {
                context.strokeEllipse(in: hole)
            }
            context.strokePath()
        }
    }
}

// MARK: - Image Cropping
extension UIImage {
    
    func cropping(to rect: CGRect) -> UIImage? {
        guard let cgimage = cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgimage, scale: scale, orientation: imageOrientation)
    }
    
}


