//
//  CALayer+Sequence.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import UIKit
import ThenFoundation
import ObjectiveC.runtime

extension CAAnimation {
    
    static var animation_associated_tag_key = "com.then.animation.associated.tag.key"
    public var tag: Int {
        get { return (objc_getAssociatedObject(self, CAAnimation.animation_associated_tag_key) as? Int) ?? 0 }
        set { objc_setAssociatedObject(self, CAAnimation.animation_associated_tag_key, newValue, .OBJC_ASSOCIATION_ASSIGN)}
    }
}

public extension CALayer {
    
    static var sequence_associated_key = "com.then.animation.sequence.associated.key"
    private var sequences: [String: AnimationSequence]? {
        get { return objc_getAssociatedObject(self, &CALayer.sequence_associated_key) as? [String : AnimationSequence] }
        set { objc_setAssociatedObject(self, &CALayer.sequence_associated_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func add(_ sequence: AnimationSequence, forKey key: String) {
        
        sequence.layer = self
        
        removeSequence(forKey: key)
        
        var currentSequences = sequences ?? [:]
        currentSequences[key] = sequence
        sequences = currentSequences
        
        sequence.run()
    }
    
    func removeAllSequences() {
        sequences?.forEach { $0.value.cancel() }
        sequences?.removeAll()
    }
    
    func removeSequence(forKey key: String) {
        sequence(forKey: key)?.cancel()
        sequences?.removeValue(forKey: key)
    }
    
    func sequenceKeys() -> [String]? {
        return sequences?.compactMap { $0.key }
    }
    
    func sequence(forKey key: String) -> AnimationSequence? {
        return sequences?[key]
    }
}
