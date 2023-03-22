//
//  ThenInputField.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/22.
//

import UIKit

public enum ThenInputFieldEditStatus {
    case idle
    case begin
    case end
}

public enum ThenInputFieldInputType {
    // only number
    case number
    // don't deal with
    case normal
    // custom regex
    case regex
}

public class ThenInputField: UIView {
    
    /// textfield's cursor
    public var isShowCursor: Bool = true 
    
    /// reload immediately
    public var isSecurity: Bool = false {
        didSet {
            if isSecurity {
                self.updateAllSecurity(isShow: true)
            } else {
                self.updateAllSecurity(isShow: false)
            }
            DispatchQueue.main.async {
                self.reloadCells()
            }
        }
    }
    /// show security view after securityDelay
    public var securityDelay: TimeInterval = 0.3
    ///
    public var keyBoardType: UIKeyboardType = .numberPad {
        didSet {
            self.textField.keyboardType = keyBoardType
        }
    }
    ///
    public var inputType: ThenInputFieldInputType = .number
    /// custom regex match
    public var inputRegex: String?
    /// oneTimeCode
    public var textContentType: UITextContentType? {
        didSet {
            self.textField.textContentType = textContentType
        }
    }
    
    public var placeholderText: String?
    
    public var isClearInBeginEditing: Bool = false
    
    public private(set) var codelength: Int = 4 {
        didSet {
            guard codelength != oldValue else { return }
            self.layout.itemsCount = codelength
            self.updateConfigurations()
        }
    }
    
    
    //MARK: - Closure
    public var textDidChangeClosure: ((_ text: String, _ isFinished: Bool) -> ())?
    
    public var textEditStatusClosure: ((_ statu: ThenInputFieldEditStatus) -> ())?
    
    public var textProcessClosure: ((_ text: String) -> (String))?
    
    public lazy var layout: ThenInputFieldFlowLayout = {
        let layout = ThenInputFieldFlowLayout()
        layout.itemsCount = codelength
        layout.itemSize = CGSize(width: 42, height: 47)
        return layout
    }()
    
    public var configuration = InputConfiguration() {
        didSet {
            guard configuration != oldValue else { return }
            self.updateConfigurations()
        }
    }
    
    public private(set) var text: String?
    
    
    //MARK: - Public Views
    public var accessoryView: UIView? {
        didSet {
            self.textField.inputAccessoryView = accessoryView
        }
    }
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            guard contentInset != oldValue else { return }
            self.collectionView.contentInset = contentInset
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Private Views
        
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collection.isHidden = true
        collection.delegate = self
        collection.dataSource = self
        collection.clipsToBounds = true
        collection.layer.masksToBounds = true
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ThenInputFieldCell.self, forCellWithReuseIdentifier: ThenInputFieldCell.Identifier)
        return collection
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(beginEdit))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    lazy var textField: TextField = {
        let input = TextField(frame: .zero)
        input.keyboardType = self.keyBoardType
        input.delegate = self
        input.addTarget(self, action: #selector(textFieldEditChange), for: .editingChanged)
        return input
    }()
    
    
    //MARK: - Private Properties
    var cellConfigurations = InputConfiguration.defaults
    
    var cellTexts: [String] = []
    
    //
    var oldlength: Int = 0
    
    var isNeedBeginEdit: Bool = false
    
    
    //MARK: - Lifecycle
    required public convenience init(_ codelength: Int, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.codelength = codelength
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // input
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textField)
        NSLayoutConstraint.activate([
            self.textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textField.widthAnchor.constraint(equalToConstant: 0),
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.heightAnchor.constraint(equalToConstant: 0)
        ])
        
        // tap
        self.addGestureRecognizer(self.tapGesture)
        //
        self.configNoti()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

//MARK: - Public
extension ThenInputField {
    
    ///
    public func loadPrepare(_ beginEdit: Bool = false) {
        guard self.codelength > 0 else {
            return
        }
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        if self.textField.text != configuration.originText {
            self.textField.text = configuration.originText
            self.textFieldEditChange()
        }
        
        if beginEdit {
            self.beginEdit()
        }
    }
        
    public func clear(_ beginEdit: Bool = false) {
        self.textField.text = ""
        self.oldlength = 0
        self.cellTexts.removeAll()
        self.updateAllSecurity(isShow: false)
        self.reloadCells()
        self.textDidChangeClosure?("", true)
        if beginEdit {
            self.beginEdit()
        }
    }
    
    /// 重载输入的数据（用来设置预设数据）
    public func reloadInputValue(_ value: String) {
        guard self.textField.text != value else {
            return
        }
        self.textField.text = value
        self.textFieldDidChange(self.textField, isManual: true)
    }
    
    public func updateSecuritySymbol(_ security: String) {
        
        if security.count != 1 {
            self.configuration.securitySymbol = "✱"
        } else {
            self.configuration.securitySymbol = security
        }
    }
    
    public func updateCodelength(_ length: Int, beginEdit: Bool) {
        guard length > 0 else {
            return
        }
        self.codelength = length
        self.updateConfigurations()
        self.clear(beginEdit)
    }
    
}

//MARK: - Private
extension ThenInputField {
    
    @objc public func beginEdit() {
        if !self.textField.isFirstResponder {
            self.textField.becomeFirstResponder()
        }
    }
    
    @objc public func endedEdit() {
        if self.textField.isFirstResponder {
            self.textField.resignFirstResponder()
        }
    }
    
    func updateConfigurations() {
        // 复制
        self.cellConfigurations = (0..<codelength).map { _ in self.configuration.copy() as! InputConfiguration }
    }
        
}

//MARK: - Security Show State
extension ThenInputField {
    
    func updateSingleSecurity(isShow: Bool, _ index: Int) {
        guard index >= 0 else { return }
        let configuration = self.cellConfigurations[index]
        configuration.isShowSecurity = isShow
    }
    
    func updateAllSecurity(isShow: Bool) {
        self.cellConfigurations.forEach {
            if $0.isShowSecurity != isShow {
                $0.isShowSecurity = isShow
            }
        }
    }
    
    /// delay replace latest cell security
    func delaySecuritylatestProcess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + securityDelay) {
            let count = self.cellTexts.count
            guard count > 0 else { return }
            self.replaceCellTexts(index: count - 1, islatest: true)
            DispatchQueue.main.async {
                self.reloadCells()
            }
        }
    }
    
    /// delay replace all cells security
    func delaySecurityAllProcess() {
        for (i, _) in self.cellTexts.enumerated() {
            self.replaceCellTexts(index: i, islatest: false)
        }
        self.reloadCells()
    }
    
    ///
    func replaceCellTexts(index: Int, islatest: Bool) {
        guard self.isSecurity else {
            return
        }
        if islatest && (index != cellTexts.count - 1) {
            return
        }
        self.updateSingleSecurity(isShow: true, index)
    }
        
}

//MARK: - Noti
extension ThenInputField {
    
    func configNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationWillResignActive(_ noti: Notification) { }
    
    @objc func applicationDidBecomeActive(_ noti: Notification) {
        self.reloadCells()
    }
    
}
