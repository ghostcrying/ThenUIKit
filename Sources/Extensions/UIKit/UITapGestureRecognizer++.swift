//
//  UITapGestureRecognizer++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/14.
//

import UIKit

public extension UITapGestureRecognizer {
    
    /// 点击富文本中标记文本
    func tapAttributedText(label: UILabel, tapTexts: [String], completion: @escaping (String, Int) -> ()) {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width)*0.5 - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height)*0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        
        if label.text == nil {
            return
        }
        
        for e in tapTexts.enumerated() {
            let targetRange: NSRange = (label.text! as NSString).range(of: e.element)
            let isContain = NSLocationInRange(indexOfCharacter, targetRange)
            if isContain {
                completion(e.element, e.offset)
            }
        }
    }
}
