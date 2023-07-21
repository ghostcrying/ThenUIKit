//
//  String++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation
import CoreGraphics.CGGeometry

public extension ThenExtension where T == String {
    
    @inlinable
    func boundingHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin).union(.truncatesLastVisibleLine)
        let boundingBox = value.boundingRect(with: constraintRect,
                                            options: options,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.height.then.ceil
    }
    
    @inlinable
    func boundingWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin).union(.truncatesLastVisibleLine)
        let boundingBox = value.boundingRect(with: constraintRect,
                                            options: options,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.width.then.ceil
    }
    
    @inlinable
    func boundingWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude,
                                    height: height)
        let boundingBox = value.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.width.then.ceil
    }
    
    @inlinable
    func boundingSize(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin).union(.truncatesLastVisibleLine)
        let boundingBox = value.boundingRect(with: constraintRect,
                                            options: options,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.size.then.ceil
    }
    
}
