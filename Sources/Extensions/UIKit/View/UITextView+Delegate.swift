//
//  UITextView+Delegate.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/22.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UITextView {
    
    @discardableResult
    func on(_ type: ThenTextViewActionTypes) -> ThenExtension {
        guard let targets = base.kit_textViewTarget else {
            base.kit_textViewTarget = TextViewDelegateTarget(base)
            base.kit_textViewTarget?.on(type)
            return self
        }
        targets.on(type)
        return self
    }
    
    @discardableResult
    func off(_ type: ThenTextViewActionTypes) -> ThenExtension {
        base.kit_textViewTarget?.off(type)
        guard let types = base.kit_textViewTarget?.types, types.count > 0 else {
            base.kit_textViewTarget = nil
            return self
        }
        return self
    }
}

public enum ThenTextViewActionTypes {
    
    case shouldBeginEditing((UITextView) -> Bool)
    case shouldEndEditing((UITextView) -> Bool)
    case beginEditing((UITextView) -> Void)
    case endEditing((UITextView) -> Void)
    case shouldReplacement((UITextView, NSRange, String) -> Bool)
    case didChange((UITextView) -> Void)
    case didChangeSelection((UITextView) -> Void)
    case shouldClear((UITextView) -> Bool)
    case shouldReturn((UITextView) -> Bool)
    
    @available(iOS 10.0, *)
    case shouldURLInteraction((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
    
    @available(iOS 10.0, *)
    case shouldAttachmentInteraction((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)
    
}

extension ThenTextViewActionTypes: RawRepresentable {
    
    public typealias RawValue = Int
    
    public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = ThenTextViewActionTypes.shouldBeginEditing({ _ -> Bool in return true })
        case 1: self = ThenTextViewActionTypes.shouldEndEditing({ _ -> Bool in return true })
        case 2: self = ThenTextViewActionTypes.beginEditing({ _ in })
        case 3: self = ThenTextViewActionTypes.endEditing({ _ in })
        case 4: self = ThenTextViewActionTypes.shouldReplacement({ (_, _, _) -> Bool in return true })
        case 5: self = ThenTextViewActionTypes.didChange({ _ in })
        case 6: self = ThenTextViewActionTypes.didChangeSelection({ _ in })
        case 7: self = ThenTextViewActionTypes.shouldClear({ _ in return true })
        case 8: self = ThenTextViewActionTypes.shouldReturn({ _ in return true })
        case 9:
            if #available(iOS 10.0, *) {
                self = ThenTextViewActionTypes.shouldURLInteraction({ (_, _, _, _) -> Bool in return true })
            } else {
                self = ThenTextViewActionTypes.shouldBeginEditing({ _ -> Bool in return true })
            }
        case 10:
            if #available(iOS 10.0, *) {
                self = ThenTextViewActionTypes.shouldAttachmentInteraction({ (_, _, _, _) -> Bool in return true })
            } else {
                self = ThenTextViewActionTypes.shouldBeginEditing({ _ -> Bool in return true })
            }
        default: self = ThenTextViewActionTypes.shouldBeginEditing({ _ -> Bool in return true })
        }
    }
    
    public var rawValue: Int {
        switch self {
        case .shouldBeginEditing(_):            return 0
        case .shouldEndEditing(_):              return 1
        case .beginEditing(_):                  return 2
        case .endEditing(_):                    return 3
        case .shouldReplacement(_):             return 4
        case .didChange(_):                     return 5
        case .didChangeSelection(_):            return 6
        case .shouldClear(_):                   return 7
        case .shouldReturn(_):                  return 8
        case .shouldURLInteraction(_):          return 9
        case .shouldAttachmentInteraction(_):   return 10
        }
    }
}

private var UITextView_Key_Target: String = "com.then.textView.target.key"
fileprivate extension UITextView {
    
    var kit_textViewTarget: TextViewDelegateTarget? {
        get { return then.binded(for: &UITextView_Key_Target) }
        set { then.bind(object: newValue, for: &UITextView_Key_Target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

fileprivate class TextViewDelegateTarget: NSObject, UITextViewDelegate {
    
    fileprivate weak var textView: UITextView?
    fileprivate var types: [Int: ThenTextViewActionTypes] = [:]
    
    fileprivate init(_ textView: UITextView?) {
        super.init()
        self.textView = textView
        self.textView?.delegate = self
    }
    
    fileprivate func on(_ type: ThenTextViewActionTypes) {
        types[type.rawValue] = type
    }
    
    fileprivate func off(_ type: ThenTextViewActionTypes) {
        types.removeValue(forKey: type.rawValue)
    }
    
    fileprivate func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let type = ThenTextViewActionTypes.shouldBeginEditing { (_) -> Bool in return true }
        guard case .shouldBeginEditing(let closure)? = types[type.rawValue] else { return true }
        return closure(textView)
    }
    
    fileprivate func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let type = ThenTextViewActionTypes.shouldEndEditing { (_) -> Bool in return true }
        guard case .shouldEndEditing(let closure)? = types[type.rawValue] else { return true }
        return closure(textView)
    }
    
    fileprivate func textViewDidBeginEditing(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.beginEditing { (_) in }
        guard case .beginEditing(let closure)? = types[type.rawValue] else { return }
        closure(textView)
    }
    
    fileprivate func textViewDidEndEditing(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.endEditing { (_) in }
        guard case .endEditing(let closure)? = types[type.rawValue] else { return }
        closure(textView)
    }
    
    fileprivate func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let shouldClear = ThenTextViewActionTypes.shouldClear { _ in return true }
        if range.length == 1, text.count == 0, case .shouldClear(let closure)? = types[shouldClear.rawValue] {
            return closure(textView)
        }
        let shouldReturn = ThenTextViewActionTypes.shouldReturn { _ in return true }
        if range.length == 0, text == "\n", case .shouldReturn(let closure)? = types[shouldReturn.rawValue] {
            return closure(textView)
        }
        let shouldReplacement = ThenTextViewActionTypes.shouldReplacement { (_, _, _) -> Bool in return true }
        if case .shouldReplacement(let closure)? = types[shouldReplacement.rawValue] {
            return closure(textView, range, text)
        }
        return true
    }
    
    fileprivate func textViewDidChange(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.didChange { (_) in }
        guard case .didChange(let closure)? = types[type.rawValue] else { return }
        closure(textView)
    }
    
    fileprivate func textViewDidChangeSelection(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.didChangeSelection { (_) in }
        guard case .didChangeSelection(let closure)? = types[type.rawValue] else { return }
        closure(textView)
    }
    
    @available(iOS 10.0, *)
    fileprivate func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let type = ThenTextViewActionTypes.shouldURLInteraction { (_, _, _, _) -> Bool in return true }
        guard case .shouldURLInteraction(let closure)? = types[type.rawValue] else { return true }
        return closure(textView, URL, characterRange, interaction)
    }
    
    @available(iOS 10.0, *)
    fileprivate func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let type = ThenTextViewActionTypes.shouldAttachmentInteraction { (_, _, _, _) -> Bool in return true }
        guard case .shouldAttachmentInteraction(let closure)? = types[type.rawValue] else { return true }
        return closure(textView, textAttachment, characterRange, interaction)
    }
}
