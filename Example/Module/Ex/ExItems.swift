//
//  ExItems.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import Foundation

enum ExItem: String {
    case base
}

enum Ex: String, CaseIterable {
    case `default`
    
    var items: [ExItem] {
        switch self {
        case .default:
            return [.base]
        default:
            return []
        }
    }
}
