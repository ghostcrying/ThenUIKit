//
//  ThenSegmentControl.swift
//  ThenUIKit
//
//  Created by ghost on 2020/3/12.
//

import ThenFoundation
import UIKit

// MARK: - ThenSegmentControl

open class ThenSegmentControl: UIScrollView {
    /// 选中的索引
    public private(set) var selectedIndex: Int = 0

    /// 展示可见的数量，可小数
    public var contentCount: CGFloat {
        get { self.contentCount_ }
        set { self.contentCount_ = newValue; setNeedsLayout() }
    }

    /// 要展示的选项
    public var items: [Item] = [] {
        didSet {
            self.segments.forEach { $0.removeFromSuperview() }
            self.segments = self.items.compactMap {
                Button(item: $0).then.on(.touchUpInside) { [weak self] in self?.action($0) }.value
            }
            self.segments.forEach { addSubview($0) }
            setNeedsLayout()
        }
    }

    /// 选中的回调
    public var selected: ((_ button: Button, _ index: Int) -> Bool)?

    /// 对应索引的按钮
    public func button(at index: Int) -> Button? {
        return self.segments[safe: index]
    }

    /// 选中指定索引的选项
    public func select(at index: Int, animated: Bool = true) {
        self.selectedIndex = index
        let size = then.size
        let ctX = min(contentSize.width - size.width, max(0, (CGFloat(self.selectedIndex) + 0.5) * size.width / self.contentCount - size.width / 2))
        setContentOffset(CGPoint(x: ctX, y: contentOffset.y), animated: animated)
        self.segments.enumerated().forEach {
            $0.element.isDidHighlighted = index == $0.offset
        }
    }

    /// 绘制边框 (默认 style:bottom, lineWidth:1, lineColor:0x646464)
    public var drawBorder: ((ThenCALayerBorder) -> Void)? = {
        $0.lineWidth = 1 / UIScreen.main.scale
        $0.lineColor = UIColor(hex: 0x646464)
        $0.style = [.bottom]
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let size = then.size
        let count = CGFloat(items.count)
        self.contentCount_ = max(1, min(self.contentCount, count))
        let buttonSize = CGSize(width: size.width / self.contentCount, height: size.height)
        self.contentSize = CGSize(width: buttonSize.width * count, height: buttonSize.height)
        self.segments.enumerated().forEach {
            $0.element.frame = CGRect(x: buttonSize.width * CGFloat($0.offset), y: 0, width: buttonSize.width, height: buttonSize.height)
        }
        if let closure = drawBorder {
            layer.then.border.make(closure)
        }
    }

    override open var contentSize: CGSize {
        didSet {
            if oldValue.equalTo(.zero), !self.contentSize.equalTo(.zero) {
                self.select(at: self.selectedIndex, animated: false)
            }
        }
    }

    private var contentCount_: CGFloat = 4
    private var segments: [Button] = []

    private func action(_ button: Button) {
        guard let selected = selected, let index = segments.firstIndex(of: button) else {
            return
        }
        if selected(button, index) {
            self.select(at: index, animated: true)
        }
    }
}

public extension ThenSegmentControl {
    class Button: UIControl {
        public var isDidHighlighted: Bool = false {
            didSet {
                self.titleLabel.isHighlighted = self.isDidHighlighted
                self.imageView.isHighlighted = self.isDidHighlighted
                self.markView.backgroundColor = self.isDidHighlighted ? self.item.highlightedColor : self.item.color
            }
        }

        public var item: Item

        @available(*, unavailable)
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public init(item: Item) {
            self.item = item
            super.init(frame: .zero)
            addSubview(self.imageView)
            addSubview(self.titleLabel)
            addSubview(self.markView)
            self.markView.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 4)
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            self.imageView.frame = bounds
            self.titleLabel.frame = bounds.inset(by: self.item.titleEdgeInset)
            self.markView.center = CGPoint(x: self.titleLabel.then.centerX, y: then.height - 7)
        }

        public lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.text = self.item.title
            label.textColor = self.item.color
            label.highlightedTextColor = self.item.highlightedColor
            label.font = self.item.titleFont
            return label
        }()

        public lazy var imageView: UIImageView = {
            let image = UIImageView()
            image.image = self.item.image
            image.highlightedImage = self.item.highlightedImage
            return image
        }()

        public lazy var markView: UIView = .init(frame: 4.then.square)
    }

    struct Item {
        public var title: String
        public var color: UIColor
        public var highlightedColor: UIColor
        public var titleFont: UIFont
        public var titleEdgeInset: UIEdgeInsets

        public var image: UIImage?
        public var highlightedImage: UIImage?

        public init(
            title: String,
            color: UIColor = UIColor.black,
            highlightedColor: UIColor = UIColor.gray,
            titleFont: UIFont = UIFont.systemFont(ofSize: 14),
            titleEdgeInset: UIEdgeInsets = .zero,
            image: UIImage? = nil,
            highlightedImage: UIImage? = nil
        ) {
            self.title = title
            self.color = color
            self.highlightedColor = highlightedColor
            self.titleFont = titleFont
            self.titleEdgeInset = titleEdgeInset
            self.image = image
            self.highlightedImage = highlightedImage
        }
    }
}
