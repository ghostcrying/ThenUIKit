//
//  CALayer+Sequence.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import ObjectiveC.runtime
import ThenFoundation
import UIKit

private enum CAAnimationKey {
    @UniqueAddress static var tag
    @UniqueAddress static var sequences
}

public extension CAAnimation {
    var tag: Int {
        get { (objc_getAssociatedObject(self, CAAnimationKey.tag) as? Int) ?? 0 }
        set { objc_setAssociatedObject(self, CAAnimationKey.tag, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

public extension CALayer {
    static var sequence_associated_key = "com.then.animation.sequence.associated.key"
    private var sequences: [String: AnimationSequence]? {
        get { objc_getAssociatedObject(self, CAAnimationKey.sequences) as? [String: AnimationSequence] }
        set { objc_setAssociatedObject(self, CAAnimationKey.sequences, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
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
