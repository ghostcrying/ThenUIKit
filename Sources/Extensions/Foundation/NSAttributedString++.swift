//
//  NSAttributedString++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation

public extension NSAttributedString {
    
    convenience init(string: String,
                     bgColorHex: Int? = nil,
                     fgColorHex: Int? = nil,
                     fontSize: CGFloat? = nil,
                     lineSpacing: CGFloat? = nil,
                     alignment: NSTextAlignment? = nil) {
        var attributes: [NSAttributedString.Key:Any] = [:]
        if let bgc = bgColorHex {
            attributes[.backgroundColor] = UIColor(hex: bgc)
        }
        if let fgc = fgColorHex {
            attributes[.foregroundColor] = UIColor(hex: fgc)
        }
        if let fs = fontSize {
            attributes[.font] = UIFont.systemFont(ofSize: fs)
        }
        if lineSpacing != nil || alignment != nil {
            let style = NSMutableParagraphStyle(lineSpacing: lineSpacing, alignment: alignment)
            attributes[.paragraphStyle] = style
        }
        self.init(string: string, attributes: attributes)
    }
    
    convenience init(string: String,
                     bgColor: UIColor? = nil,
                     fgColor: UIColor? = nil,
                     font: UIFont? = nil,
                     style: NSParagraphStyle? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let bgc = bgColor {
            attributes[.backgroundColor] = bgc
        }
        if let fgc = fgColor {
            attributes[.foregroundColor] = fgc
        }
        if let ft = font {
            attributes[.font] = ft
        }
        if let sy = style {
            attributes[.paragraphStyle] = sy
        }
        self.init(string: string, attributes: attributes)
    }
}

public extension ThenExtension where T == NSAttributedString {
    
    func attribute(lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, for range: NSRange? = nil) -> NSMutableAttributedString {
        return value.attribute(lineSpacing: lineSpacing, alignment: alignment, for: range)
    }
    
    func attribute(textColor: UIColor, for range: NSRange? = nil) -> NSMutableAttributedString {
        return value.attribute(textColor: textColor, for: range)
    }
    
    func attribute(textFont: UIFont, for range: NSRange? = nil) -> NSMutableAttributedString {
        return value.attribute(textFont: textFont, for: range)
    }
}

public extension ThenExtension where T == NSMutableAttributedString {
    
    @discardableResult
    func update(textColor: UIColor, for range: NSRange? = nil) -> ThenExtension {
        value.update(textColor: textColor, for: range)
        return self
    }
    
    @discardableResult
    func update(textFont: UIFont, for range: NSRange? = nil) -> ThenExtension {
        value.update(textFont: textFont, for: range)
        return self
    }
    
    @discardableResult
    func update(lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, for range: NSRange? = nil) -> ThenExtension {
        value.update(lineSpacing: lineSpacing, alignment: alignment, for: range)
        return self
    }
}

extension NSAttributedString {
    
    func attribute(lineSpacing: CGFloat? = nil,
                   alignment: NSTextAlignment? = nil,
                   for range: NSRange? = nil) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        mAttString.update(lineSpacing: lineSpacing, alignment: alignment, for: range)
        return mAttString
    }
    
    func attribute(textColor: UIColor, for range: NSRange? = nil) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        mAttString.update(textColor: textColor, for: range)
        return mAttString
    }
    
    func attribute(textFont: UIFont, for range: NSRange? = nil) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        mAttString.update(textFont: textFont, for: range)
        return mAttString
    }
}

extension NSMutableAttributedString {
    
    func update(textColor: UIColor, for range: NSRange? = nil) {
        let att = [NSAttributedString.Key.foregroundColor: textColor]
        self.addAttributes(att, range: range ?? NSRange(location: 0, length: self.length))
    }
    
    func update(textFont: UIFont, for range: NSRange? = nil) {
        let att = [NSAttributedString.Key.font: textFont]
        self.addAttributes(att, range: range ?? NSRange(location: 0, length: self.length))
    }
    
    func update(lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, for range: NSRange? = nil) {
        let style = NSMutableParagraphStyle(lineSpacing: lineSpacing, alignment: alignment)
        let att = [NSAttributedString.Key.paragraphStyle:style]
        addAttributes(att, range: range ?? NSRange(location: 0, length: self.length))
    }
}
