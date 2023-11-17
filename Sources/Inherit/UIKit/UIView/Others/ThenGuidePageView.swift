//
//  ThenGuidePageView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/10.
//

import ThenFoundation
import UIKit

public extension ThenGuidePageView {
    /**
     skipTitle: 跳过按钮的标题
     imageNames: 本地图片名称
     inView: 展示在哪个视图上
     force: 是否强制展示，不管是不是第一次
     dismiss: 消失前的回调
     */
    class func show(
        skip title: String? = "立即体验",
        images imageNames: [String]?,
        in view: UIView,
        force forceShow: Bool = false,
        _ dismiss: (() -> Void)?
    ) -> Bool {
        guard let names = imageNames else {
            return false
        }
        if !forceShow {
            let version = Bundle.main.then.version
            let didVersion = UserDefaults.standard.value(forKey: ThenGuidePageView.storeKey) as? String
            if version == didVersion {
                return false
            }
        }
        view.endEditing(true)
        let guideView = ThenGuidePageView(frame: UIScreen.main.bounds)
        guideView.skipTitle = title
        guideView.imageNames = names
        guideView.dismiss = dismiss
        guideView.pageControl.index = 0
        view.addSubview(guideView)
        return true
    }
}

// MARK: - ThenGuidePageView

@IBDesignable open class ThenGuidePageView: UIView {
    static let storeKey = "com.then.park.guide"

    /// 留边
    @IBInspectable
    open var contentInsets: UIEdgeInsets = .zero
    /// 间距
    @IBInspectable
    open var gap: CGSize = .zero

    /// 跳过按钮的标题
    open var skipTitle: String? {
        get { enter.title(for: .normal) }
        set { enter.setTitle(newValue, for: .normal) }
    }

    /// 本地图片名称
    open var imageNames: [String] = [] {
        didSet {
            pageControl.totalCount = imageNames.count
            collectionView.reloadData()
        }
    }

    /// 消失前的回调
    open var dismiss: (() -> Void)?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.collectionView)
        addSubview(self.pageControl)
        addSubview(self.enter)
    }

    /// 重新布局
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = bounds
        self.pageControl.center = CGPoint(x: bounds.then.centerX, y: bounds.height - 78)
        self.enter.center = CGPoint(x: bounds.then.centerX, y: self.pageControl.then.centerY)
    }

    /// 表格视图
    open lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = .zero
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.then.registerClassWithCell(Cell.self)
        return cv
    }()

    /// 翻页指示器
    open lazy var pageControl: PageControl = {
        let view = PageControl(frame: CGSize(width: 300, height: 12).then.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }()

    /// 进入按钮
    open lazy var enter: UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 48))
        button.backgroundColor = UIColor(hex: 0x8B49F6)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("立即体验", for: .normal)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
        button.then.on(.touchUpInside) { [weak self] in self?.enterButtonAction($0) }
        button.alpha = 0
        return button
    }()

    /// 进入按钮的触发事件
    open func enterButtonAction(_ button: UIButton) {
        if let version = Bundle.main.then.version {
            UserDefaults.standard.setValue(version, forKey: ThenGuidePageView.storeKey)
            UserDefaults.standard.synchronize()
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.dismiss?()
            self.removeFromSuperview()
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ThenGuidePageView: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return then.size
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ThenGuidePageView: UICollectionViewDataSource, UICollectionViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        offset.x = min(scrollView.contentSize.width - scrollView.then.width, max(0, offset.x))
        scrollView.contentOffset = offset

        let ix = 0.5 + offset.x / scrollView.then.width
        self.pageControl.index = Int(ix)

        let cut = 1.5 * scrollView.then.width
        if offset.x < (scrollView.contentSize.width - cut) {
            self.enter.isHidden = true
            return
        }
        let less = offset.x - cut
        let p = less / (scrollView.then.width / 2.0)

        self.enter.isHidden = false
        self.pageControl.alpha = 1.0 - p
        self.enter.alpha = p
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.then.dequeueCell(Cell.self, for: indexPath)
        if let imageNamed = imageNames[safe: indexPath.item] {
            cell.imageView.image = UIImage(named: imageNamed)
        }
        return cell
    }
}

// MARK: - ThenGuidePageView.PageControl

public extension ThenGuidePageView {
    @IBDesignable
    class PageControl: UIView {
        /// 留边
        @IBInspectable
        open var contentInsets: UIEdgeInsets = .zero
        /// 间距
        @IBInspectable
        open var gap: CGSize = .zero

        public enum Block {
            public static var color = UIColor(hex: 0xCCCCCC)
            public static var tintColor = UIColor(hex: 0x8B49F6)
            public static var size: CGSize = 8.then.size
        }

        public var totalCount: Int = 0 {
            didSet {
                self.blockViews.forEach { vw in vw.removeFromSuperview() }
                self.blockViews.removeAll()
                self.totalCount.then.repeating { _ in
                    let v = UIView(frame: Block.size.then.bounds)
                    v.backgroundColor = Block.color
                    addSubview(v)
                    self.blockViews.append(v)
                }
                self.index = min(max(0, self.totalCount - 1), self.index)
                setNeedsLayout()
            }
        }

        public var index: Int = -1 {
            didSet {
                if oldValue == self.index {
                    return
                }
                if let oldVw = blockViews[safe: oldValue] {
                    UIView.animate(withDuration: 0.2, animations: {
                        oldVw.backgroundColor = Block.color
                        oldVw.transform = CGAffineTransform.identity
                    })
                }
                if let newVw = blockViews[safe: index] {
                    UIView.animate(withDuration: 0.2, animations: {
                        newVw.backgroundColor = Block.tintColor
                        newVw.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
                    })
                }
            }
        }

        public var blockViews = [UIView]()

        // MARK: Life cycle

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override public init(frame: CGRect) {
            super.init(frame: frame)
            self.gap = CGSize(width: 12, height: 0)
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            let inFrame = bounds.inset(by: self.contentInsets)
            let totalWidth = self.gap.width * CGFloat(max(0, self.totalCount - 1)) + CGFloat(self.totalCount) * Block.size.width
            var center_x = inFrame.then.left + (inFrame.width - totalWidth) / 2.0 + Block.size.width / 2
            self.blockViews.forEach {
                $0.center = CGPoint(x: center_x, y: inFrame.then.centerY)
                center_x += (self.gap.width + Block.size.width)
            }
        }
    }
}

// MARK: - ThenGuidePageView.Cell

public extension ThenGuidePageView {
    class Cell: UICollectionViewCell {
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override public init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(self.imageView)
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            self.imageView.frame = bounds
        }

        public lazy var imageView: UIImageView = .init()
    }
}
