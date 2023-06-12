//
//  UITextView++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/17.
//

import UIKit
import ThenFoundation

public extension ThenExtension where T: UITextView {
    
    /// Move Cursor To Last Insert
    func movelastCursor() -> ThenExtension {
        value.movelastCursor()
        return self
    }
}

public extension UITextView {
    
    /// 移动光标到最后
    func movelastCursor() {
        guard let start = position(from: beginningOfDocument, offset: text?.utf16.count ?? 0), let ended = position(from: start, offset: 0) else {
            return
        }
        let select = textRange(from: start, to: ended)
        if let current = selectedTextRange {
            if current != select {
                self.selectedTextRange = select
            }
        }
    }
    
    // maxlength: 限制输入长度
    // 返回元祖:
    // - Bool: 是否可以返回
    // - String: 显示的文本
    func shouldChange(maxlength: Int, range: NSRange, replace: String) -> (Bool, String) {
        // 原始文本
        let t = text ?? ""
        // 替换后的文本
        let latest = (t as NSString).replacingCharacters(in: range, with: replace)
        // 删除
        guard !replace.isEmpty else {
            return (true, latest)
        }
        // 替换后的文本满足限制
        guard latest.utf16.count > maxlength else {
            return (true, latest)
        }
        // 原始长度必须小于限制
        guard t.utf16.count < maxlength else {
            return (false, t)
        }
        // 原始文本满足限制且替换后文本不满足限制: 进行切割
        // 计算切割后的文本
        let s1 = replace.realSubString(to: (maxlength - t.utf16.count))
        // 得到最终的文本
        let t1 = (t as NSString).substring(to: range.location) + s1
        let t2 = (t as NSString).substring(from: range.location)
        let last = t1 + t2
        // 更改输入文本
        text = last
        // 移动光标
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let start = self.position(from: self.beginningOfDocument, offset: t1.utf16.count), let ended = self.position(from: start, offset: 0) {
                self.selectedTextRange = self.textRange(from: start, to: ended)
            }
        }
        return (false, last)
    }
}

internal extension String {
    
    /// 截取包含emoji字符串
    func realSubString(to: Int) -> String {
        guard utf16.count > to else { return self }
        guard to > 0 else { return "" }
        // 截取字符串: 最终坑会出现半个emoji文本, 显示乱码
        let text = (self as NSString).substring(to: to)
        if #available(iOS 13.0, *) {
            guard let data = text.data(using: .utf8), let temp = NSString(data: data, encoding: String.Encoding.utf8.rawValue), temp.contains("\u{0000fffd}") else {
                return text
            }
            return temp.replacingOccurrences(of: "\u{0000fffd}", with: "") as String
        } else {
            if let last = text.last, let data = String(last).data(using: .utf8), let temp = NSString(data: data, encoding: String.Encoding.utf8.rawValue), temp.contains("\u{0000fffd}") {
                return (text as NSString).substring(to: text.utf16.count-1)
            }
            return text
        }
    }
}
