//
//  UIAlertController+DatePicker.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/14.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UIAlertController {
    
    /// Add a picker view
    /// - Parameter config: the alert config
    @discardableResult
    func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: ((Date) -> ())? = nil) -> ThenExtension {
        value.addDatePicker(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        return self
    }
}

public extension UIAlertController {
    
    /// Add a date picker
    /// - Parameters:
    ///   - mode: date picker mode
    ///   - date: selected date of date picker
    ///   - minimumDate: minimum date of date picker
    ///   - maximumDate: maximum date of date picker
    ///   - action: an action for datePicker value change
    func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: ((Date) -> ())? = nil) {
        let datePicker = DatePickerViewController(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        set(vc: datePicker, height: 217)
    }
}

final class DatePickerViewController: UIViewController {
    
    fileprivate var action: ((Date) -> ())?
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    required init(mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: ((Date) -> ())?) {
        super.init(nibName: nil, bundle: nil)
        datePicker.datePickerMode = mode
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("has deinitialized")
    }
    
    override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}

