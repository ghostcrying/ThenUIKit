//
//  UITextView+Delegate.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/22.
//

import ThenFoundation
import UIKit

public extension ThenExtension where T: UITextView {
    @discardableResult
    func on(_ type: ThenTextViewActionTypes) -> ThenExtension {
        guard let targets = value.kit_textViewTarget else {
            value.kit_textViewTarget = TextViewDelegateTarget(value)
            value.kit_textViewTarget?.on(type)
            return self
        }
        targets.on(type)
        return self
    }

    @discardableResult
    func off(_ type: ThenTextViewActionTypes) -> ThenExtension {
        value.kit_textViewTarget?.off(type)
        guard let types = value.kit_textViewTarget?.types, types.count > 0 else {
            value.kit_textViewTarget = nil
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
        case 0: self = ThenTextViewActionTypes.shouldBeginEditing { _ -> Bool in true }
        case 1: self = ThenTextViewActionTypes.shouldEndEditing { _ -> Bool in true }
        case 2: self = ThenTextViewActionTypes.beginEditing { _ in }
        case 3: self = ThenTextViewActionTypes.endEditing { _ in }
        case 4: self = ThenTextViewActionTypes.shouldReplacement { _, _, _ -> Bool in true }
        case 5: self = ThenTextViewActionTypes.didChange { _ in }
        case 6: self = ThenTextViewActionTypes.didChangeSelection { _ in }
        case 7: self = ThenTextViewActionTypes.shouldClear { _ in true }
        case 8: self = ThenTextViewActionTypes.shouldReturn { _ in true }
        case 9:
            if #available(iOS 10.0, *) {
                self = ThenTextViewActionTypes.shouldURLInteraction { _, _, _, _ -> Bool in true }
            } else {
                self = ThenTextViewActionTypes.shouldBeginEditing { _ -> Bool in true }
            }
        case 10:
            if #available(iOS 10.0, *) {
                self = ThenTextViewActionTypes.shouldAttachmentInteraction { _, _, _, _ -> Bool in true }
            } else {
                self = ThenTextViewActionTypes.shouldBeginEditing { _ -> Bool in true }
            }
        default: self = ThenTextViewActionTypes.shouldBeginEditing { _ -> Bool in true }
        }
    }

    public var rawValue: Int {
        switch self {
        case .shouldBeginEditing: return 0
        case .shouldEndEditing: return 1
        case .beginEditing: return 2
        case .endEditing: return 3
        case .shouldReplacement: return 4
        case .didChange: return 5
        case .didChangeSelection: return 6
        case .shouldClear: return 7
        case .shouldReturn: return 8
        case .shouldURLInteraction: return 9
        case .shouldAttachmentInteraction: return 10
        }
    }
}

private enum UITextViewAssociation {
    @UniqueAddress static var target
}

private extension UITextView {
    var kit_textViewTarget: TextViewDelegateTarget? {
        get { then.binded(for: UITextViewAssociation.target) }
        set { then.bind(object: newValue, for: UITextViewAssociation.target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private class TextViewDelegateTarget: NSObject, UITextViewDelegate {
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
        let type = ThenTextViewActionTypes.shouldBeginEditing { _ -> Bool in true }
        guard case let .shouldBeginEditing(closure)? = types[type.rawValue] else {
            return true
        }
        return closure(textView)
    }

    fileprivate func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let type = ThenTextViewActionTypes.shouldEndEditing { _ -> Bool in true }
        guard case let .shouldEndEditing(closure)? = types[type.rawValue] else {
            return true
        }
        return closure(textView)
    }

    fileprivate func textViewDidBeginEditing(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.beginEditing { _ in }
        guard case let .beginEditing(closure)? = types[type.rawValue] else {
            return
        }
        closure(textView)
    }

    fileprivate func textViewDidEndEditing(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.endEditing { _ in }
        guard case let .endEditing(closure)? = types[type.rawValue] else {
            return
        }
        closure(textView)
    }

    fileprivate func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let shouldClear = ThenTextViewActionTypes.shouldClear { _ in true }
        if range.length == 1, text.count == 0, case let .shouldClear(closure)? = types[shouldClear.rawValue] {
            return closure(textView)
        }
        let shouldReturn = ThenTextViewActionTypes.shouldReturn { _ in true }
        if range.length == 0, text == "\n", case let .shouldReturn(closure)? = types[shouldReturn.rawValue] {
            return closure(textView)
        }
        let shouldReplacement = ThenTextViewActionTypes.shouldReplacement { _, _, _ -> Bool in true }
        if case let .shouldReplacement(closure)? = types[shouldReplacement.rawValue] {
            return closure(textView, range, text)
        }
        return true
    }

    fileprivate func textViewDidChange(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.didChange { _ in }
        guard case let .didChange(closure)? = types[type.rawValue] else {
            return
        }
        closure(textView)
    }

    fileprivate func textViewDidChangeSelection(_ textView: UITextView) {
        let type = ThenTextViewActionTypes.didChangeSelection { _ in }
        guard case let .didChangeSelection(closure)? = types[type.rawValue] else {
            return
        }
        closure(textView)
    }

    @available(iOS 10.0, *)
    fileprivate func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let type = ThenTextViewActionTypes.shouldURLInteraction { _, _, _, _ -> Bool in true }
        guard case let .shouldURLInteraction(closure)? = types[type.rawValue] else {
            return true
        }
        return closure(textView, URL, characterRange, interaction)
    }

    @available(iOS 10.0, *)
    fileprivate func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let type = ThenTextViewActionTypes.shouldAttachmentInteraction { _, _, _, _ -> Bool in true }
        guard case let .shouldAttachmentInteraction(closure)? = types[type.rawValue] else {
            return true
        }
        return closure(textView, textAttachment, characterRange, interaction)
    }
}
