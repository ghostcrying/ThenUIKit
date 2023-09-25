//
//  UniqueAddress.swift
//  ThenUIKit
//
//  Created by 陈卓 on 2023/9/25.
//

import Foundation

@propertyWrapper class UniqueAddress {
    var wrappedValue: UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
    }

    init() {}
}
