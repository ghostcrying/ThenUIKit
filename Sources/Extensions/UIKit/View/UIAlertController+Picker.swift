//
//  UIAlertController+Picker.swift
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
    func addPickerView(config: AlertPickerConfig) -> ThenExtension {
        value.addPickerView(config: config)
        return self
    }
}

public extension UIAlertController {
    
    /// Add a picker view
    /// - Parameter config: the alert config
    func addPickerView(config: AlertPickerConfig) {
        let pickerView = PickerController(config: config)
        set(vc: pickerView)
    }
}

public struct AlertPickerConfig {
    typealias Values = [[String]]
    typealias Index = (column: Int, row: Int)
    typealias Action = (_ vc: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> ()
    
    /// values for picker view
    let values: Values
    /// initial selection of picker view
    let initialSelection: Index?
    /// action for selected value of picker view
    let action: Action?
}

final class PickerController: UIViewController {
            
    fileprivate lazy var pickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    fileprivate let config: AlertPickerConfig
    init(config: AlertPickerConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // print("PickerController has deinitialized")
    }
    
    override func loadView() {
        view = pickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let initialSelection = config.initialSelection, config.values.count > initialSelection.column, config.values[initialSelection.column].count > initialSelection.row {
            pickerView.selectRow(initialSelection.row, inComponent: initialSelection.column, animated: true)
        }
    }
}

extension PickerController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return config.values.count
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return config.values[component].count
    }
    /*
     // returns width of column and height of row for each component.
     public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
     
     }
     
     public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
     
     }
     */
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return config.values[component][row]
    }
    /*
     public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     // attributed title is favored if both methods are implemented
     }
     
     
     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     
     }
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        config.action?(self, pickerView, AlertPickerConfig.Index(column: component, row: row), config.values)
    }
}

