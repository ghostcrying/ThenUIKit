//
//  ThenInputFieldConfiguration.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/22.
//

import UIKit

//MARK: - InputConfiguration
extension ThenInputField {
    ///
    public enum SecurityType {
        case symbol
        case custom
    }
    
    public class InputConfiguration: NSObject {
            
        /// cell's border with
        public var borderWidth: CGFloat = 0.5
        
        
        //MARK: - Border Color
        /// cell's border color with normal state
        public var borderColorNormal: UIColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
        
        /// cell's border color with selected state
        public var borderColorSelect: UIColor = UIColor(red: 255/255.0, green: 70/255.0, blue: 62/255.0, alpha: 1)
        
        /// cell's border color with filled state
        public var borderColorFilled: UIColor?
        
        
        //MARK: - Background Color
        /// cell's background color with normal state
        public var backColorNormal: UIColor = UIColor.white
        
        /// cell's background color with selected state
        public var backColorSelect: UIColor = UIColor.white
        
        /// cell's background color with filled state
        public var backColorFilled: UIColor?
        
        
        //MARK: - Cursor
        /// textfield's cursor color: 光标颜色
        public var cursorColor: UIColor = UIColor(red: 255/255.0, green: 70/255.0, blue: 62/255.0, alpha: 1)
        
        /// cursor view's width  ( just like textfield's cursor )
        public var cursorWidth: CGFloat = 2
        
        /// cursor view's height
        public var cursorHeight: CGFloat = 32
        
        /// cell's corner radius
        public var cornerRadius: CGFloat = 4
        
        
        //MARK: - Text Property
        /// if show underline
        public var showline: Bool = false
        
        public var textFont: UIFont = UIFont.systemFont(ofSize: 20)
        
        public var textColor: UIColor = UIColor.black
        
        
        //MARK: - Security
        /// if show security
        public var isShowSecurity: Bool = false
        /// security text, only available on isShowSecurity == true
        public var securitySymbol: String = "✱"
        
        /// origin text
        public var originText: String = ""
        /// security's type
        public var securityType: SecurityType = .symbol
        
        
        //MARK: - PlaceHolder
        /// placeholder's text
        public var placeholderText: String?
        /// placeholder's font
        public var placeholderColor: UIColor = UIColor(red: 114/255.0, green: 126/255.0, blue: 124/255.0, alpha: 0.3)
        /// placeholder's font
        public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 20)
        
        
        //MARK: - Custom
        /// custom's underline view
        public var customlineViewClosure: (() -> (ThenInputLineView)) = {
            return ThenInputLineView()
        }
        
        /// custom's security view
        public var customSecurityViewClosure: (() -> (UIView))?
        ///
        public var shadowClosure: ((CALayer) -> ())?
        
        /// current cell's row value
        public var currentIndex: Int = 0
                
        ///
        static let defaults = [InputConfiguration(), InputConfiguration(), InputConfiguration(), InputConfiguration()]
    }
    
}

//MARK: - NSCopying
extension ThenInputField.InputConfiguration: NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let config = ThenInputField.InputConfiguration()
        
        // border
        config.cornerRadius = self.cornerRadius
        config.borderWidth = self.borderWidth
        config.borderColorNormal = self.borderColorNormal
        config.borderColorSelect = self.borderColorSelect
        config.borderColorFilled = self.borderColorFilled
        
        // background
        config.backColorNormal = self.backColorNormal
        config.backColorSelect = self.backColorSelect
        config.backColorFilled = self.backColorFilled
        
        // cursor
        config.cursorColor = self.cursorColor
        config.cursorWidth = self.cursorWidth
        config.cursorHeight = self.cursorHeight
        
        // text
        config.textFont = self.textFont
        config.textColor = self.textColor
        config.originText = self.originText
        
        // security
        config.isShowSecurity = self.isShowSecurity
        config.securitySymbol = self.securitySymbol
        config.securityType   = self.securityType
        config.customSecurityViewClosure = self.customSecurityViewClosure
        
        // placeholder
        config.placeholderText = self.placeholderText
        config.placeholderFont = self.placeholderFont
        config.placeholderColor = self.placeholderColor
        
        // line
        config.showline = self.showline
        config.customlineViewClosure = self.customlineViewClosure
        
        // shadow
        config.shadowClosure = self.shadowClosure
        
        config.currentIndex = self.currentIndex
                
        return config
    }
    
}
