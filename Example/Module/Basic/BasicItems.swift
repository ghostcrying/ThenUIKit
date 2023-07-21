//
//  BasicItems.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import Foundation

enum BasicItem: String {
    case base
}

enum Basic: String, CaseIterable {
    case `default`
    
    var items: [BasicItem] {
        switch self {
        case .default:
            return [.base]
        default:
            return []
        }
    }
}
