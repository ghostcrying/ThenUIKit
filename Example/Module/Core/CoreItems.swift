//
//  CoreItems.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import Foundation

enum CoreItem: String {
    case base
}

enum Core: String, CaseIterable {
    case `default`
    
    var items: [CoreItem] {
        switch self {
        case .default:
            return [.base]
        default:
            return []
        }
    }
}
