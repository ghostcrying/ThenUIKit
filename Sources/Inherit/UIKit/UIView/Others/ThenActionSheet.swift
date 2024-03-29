//
//  ThenActionSheet.swift
//  ThenUIKit
//
//  Created by ghost on 2020/7/31.
//

import UIKit
import ThenFoundation

open class ThenActionSheet: NSObject {
    
    // MARK: Public
    public init(title: String?) {
        super.init()
        backgroundView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.titleItem = ThenActionSheetItem(title, .title, nil)
    }
    
    public func add(_ title: String, _ action: (() -> Void)? = nil) {
        if isShow { return }
        items.append(ThenActionSheetItem(title, .cell) {
            action?()
            self.dismiss()
        })
    }
    
    public func add(_ icon: UIImage?, _ title: String, _ action: (() -> Void)? = nil) {
        if isShow { return }
        items.append(ThenActionSheetItem(icon, title, .cell) {
            action?()
            self.dismiss()
        })
    }
    
    public func add(_ title: NSAttributedString, _ action: (() -> Void)? = nil) {
        if isShow { return }
        items.append(ThenActionSheetItem(title, .cell) {
            action?()
            self.dismiss()
        })
    }
    
    public func add(cancel title: String, _ action: (() -> Void)? = nil) {
        self.cancelItem = ThenActionSheetItem(title, .cancel) {
            action?()
            self.dismiss()
        }
    }
    
    public func show(inView: UIView) {
        
        isShow = true
        
        backgroundView.frame = inView.bounds
        backgroundView.addSubview(contentView)
        
        var sections = [ThenActionSheetSectionItem]()
        var height: CGFloat = UIScreen.isXGroup ? 30 : 0
        if let h = titleItem, let _ = h.title {
            height += ThenActionSheet.cellHeight
            sections.append(ThenActionSheetSectionItem(rows: [h]))
        }
        
        height += ThenActionSheet.cellHeight * CGFloat(items.count)
        sections.append(ThenActionSheetSectionItem(rows: items))
        
        if let f = cancelItem {
            height += (ThenActionSheet.cellHeight + ThenActionSheet.separatorHeight)
            sections.append(ThenActionSheetSectionItem(rows: [f]))
        }
        
        contentView.then.layout {
            $0.size = CGSize(width: self.backgroundView.then.width, height: height)
            $0.bottom = self.backgroundView.then.height
        }
        contentView.actions = sections
        
        inView.addSubview(backgroundView)
        
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.then.height)
        
        backgroundView.backgroundColor = .clear
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.contentView.transform = .identity
        }
    }
    
    @objc public func dismiss() {
        isShow = false
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.backgroundColor = .clear
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.then.height)
        }) { (finished) in
            self.backgroundView.removeFromSuperview()
        }
    }
    
    // MARK: Private
    private var isShow: Bool = false
    private var titleItem: ThenActionSheetItem?
    private var items = [ThenActionSheetItem]()
    private var cancelItem: ThenActionSheetItem?
    
    private let backgroundView = UIButton()
    private let contentView = ThenActionSheetContentView()
    
    fileprivate static let cellHeight: CGFloat = 48.0
    fileprivate static let separatorHeight: CGFloat = 10.0
}

fileprivate enum ThenActionSheetType {
    case title
    case cell
    case cancel
}

fileprivate struct ThenActionSheetItem {
    
    var icon: UIImage?
    var title: String?
    var type: ThenActionSheetType = .cell
    var action:(() -> ())?
    
    init(_ title: String?, _ type: ThenActionSheetType, _ action:(() -> Void)?) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    init(_ icon: UIImage?, _ title: String?, _ type: ThenActionSheetType, _ action:(() -> Void)?) {
        self.icon = icon
        self.title = title
        self.type = type
        self.action = action
    }
    
    var attributedTitle: NSAttributedString?
    init(_ title: NSAttributedString?, _ type: ThenActionSheetType, _ action:(() -> Void)?) {
        self.attributedTitle = title
        self.type = type
        self.action = action
    }
}

fileprivate struct ThenActionSheetSectionItem {
    var rows = [ThenActionSheetItem]()
}

private class ThenActionSheetContentView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var actions: [ThenActionSheetSectionItem]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: 0xf5f5f5)
        tableView.rowHeight = ThenActionSheet.cellHeight
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.isXGroup ? 30 : 0, right: 0))
    }
    
    lazy var tableView: UITableView = {
        let t = UITableView(frame: self.bounds, style: .plain)
        t.separatorStyle = .none
        t.separatorColor = .clear
        t.then.registerClassWithCell(ThenActionSheetCell.self)
        t.dataSource = self
        t.delegate = self
        t.isScrollEnabled = false
        return t
    }()
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return actions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions?[safe: section]?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.then.dequeueCell(ThenActionSheetCell.self)
        guard let item = actions?[safe: indexPath.section]?.rows[safe: indexPath.row] else { return cell }
        if let attText = item.attributedTitle {
            cell.titleLabel.attributedText = attText
        } else {
            cell.titleLabel.text = item.title
        }
        cell.iconView.image = item.icon
        switch item.type {
        case .title:
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(hex: 0xf5f5f5)
            cell.isTopLineHidden = true
            cell.titleLabel.textColor = UIColor(hex: 0x646464)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
        case .cancel:
            cell.selectionStyle = .default
            cell.backgroundColor = UIColor(hex: 0xffffff)
            if let sectionCount = actions?.count {
                cell.isTopLineHidden = (sectionCount == 3 ? (indexPath.row == 0) : true)
            }
            cell.titleLabel.textColor = UIColor(hex: 0xed5564)
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        default:
            cell.selectionStyle = .default
            cell.backgroundColor = UIColor(hex: 0xffffff)
            if let sectionCount = actions?.count {
                cell.isTopLineHidden = (sectionCount == 2 ? (indexPath.row == 0) : false)
            }
            cell.titleLabel.textColor = UIColor(hex: 0x313131)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(hex: 0xf5f5f5)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == (actions?.count ?? 0) - 1) ? ThenActionSheet.separatorHeight : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sections = actions else { return }
        let section = sections[indexPath.section]
        let item = section.rows[indexPath.row]
        item.action?()
    }
}

private class ThenActionSheetCell: UITableViewCell {
    
    fileprivate var contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var gap: CGSize = CGSize.zero
    
    fileprivate var topLineInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { setNeedsLayout() }
    }
    
    fileprivate var bottomLineInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { setNeedsLayout() }
    }
    
    fileprivate var isTopLineHidden: Bool {
        get { topLine.isHidden }
        set { topLine.isHidden = newValue }
    }
    
    fileprivate var isBottomLineHidden: Bool {
        get { bottomLine.isHidden }
        set { bottomLine.isHidden = newValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        contentView.addSubview(topLine)
        contentView.addSubview(bottomLine)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gap = CGSize(width: 15, height: 0)
        contentInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        contentView.addSubview(topLine)
        contentView.addSubview(bottomLine)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topLine.then.layout {
            $0.width = bounds.inset(by: topLineInsets).width
            $0.top = self.bounds.minY + self.topLineInsets.top
            $0.left = topLineInsets.left
        }
        
        bottomLine.then.layout {
            $0.width = bounds.inset(by: bottomLineInsets).width
            $0.bottom = bounds.maxY - bottomLineInsets.bottom
            $0.left = bottomLineInsets.left
        }
        
        let inFrame = contentView.bounds.inset(by: contentInsets)
        if iconView.image == nil {
            titleLabel.frame = inFrame
            titleLabel.textAlignment = .center
        } else {
            iconView.then.layout {
                $0.left = inFrame.minX
                $0.centerY = inFrame.midY
            }
            titleLabel.frame = inFrame.inset(by: UIEdgeInsets(top: 0, left: iconView.bounds.width + gap.width, bottom: 0, right: 0))
            titleLabel.textAlignment = .left
        }
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        contentView.bringSubviewToFront(topLine)
        contentView.bringSubviewToFront(bottomLine)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topLine.isHidden = true
        bottomLine.isHidden = true
        contentView.bringSubviewToFront(topLine)
        contentView.bringSubviewToFront(bottomLine)
        iconView.image = nil
    }
    
    fileprivate lazy var topLine: UIView = {
        let l = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        l.backgroundColor = UIColor(hex: 0xe7e7e7)
        l.isHidden = true
        return l
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let l = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        l.backgroundColor = UIColor(hex: 0xe7e7e7)
        l.isHidden = true
        return l
    }()
    
    fileprivate lazy var iconView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        return imgView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.textColor = UIColor(hex: 0x313131)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
}
