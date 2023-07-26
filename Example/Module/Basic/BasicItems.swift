//
//  BasicItems.swift
//  Example
//
//  Created by ghost on 2023/7/21.
//

import UIKit

enum BasicItem: String {
    case base
    case launch
    case crop
    
    var controller: UIViewController {
        switch self {
        case .base:
            return UIViewController()
        case .launch:
            return LaunchController()
        case .crop:
            return CropRouter.createModule()
        }
    }
}

enum Basic: String, CaseIterable {
    case `default`
    
    var items: [BasicItem] {
        switch self {
        case .default:
            return [.base, .launch, .crop]
        default:
            return []
        }
    }
}
