//
//  CALayer+Group.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/16.
//

import ObjectiveC.runtime
import ThenFoundation
import UIKit

private enum AnimationLayerKey {
    @UniqueAddress static var group
}

public extension CALayer {
    private var groups: [String: AnimationGroup]? {
        get { objc_getAssociatedObject(self, AnimationLayerKey.group) as? [String: AnimationGroup] }
        set { objc_setAssociatedObject(self, AnimationLayerKey.group, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func add(_ group: AnimationGroup, forKey key: String) {
        group.layer = self

        removeGroup(forKey: key)

        var currentGroups = groups ?? [:]
        currentGroups[key] = group
        groups = currentGroups

        group.run()
    }

    func removeAllGroups() {
        groups?.forEach { $0.value.cancel() }
        groups?.removeAll()
    }

    func removeGroup(forKey key: String) {
        group(forKey: key)?.cancel()
        groups?.removeValue(forKey: key)
    }

    func groupKeys() -> [String]? {
        return groups?.compactMap { $0.key }
    }

    func group(forKey key: String) -> AnimationGroup? {
        return groups?[key]
    }
}
