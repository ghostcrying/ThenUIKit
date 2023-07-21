//
//  Items.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit
import Foundation

enum InheritItem: String {
    case colorButton
    case hud
    case actionsheet
    case guide
    case monitor
    case popupMenu
    case segment
    case wave
    case progress
    case scan
    case scene
    case collectionview
    
    case textfield
    case textview
    
    case image
    
    case group
    case sequence
    
    
    var controller: UIViewController {
        switch self {
        case .colorButton:
            return ColorButtonController()
        case .collectionview:
            return CollectionController()
        default:
            return UIViewController()
        }
    }
}

enum Inherit: String, CaseIterable {
    case view
    case controller
    case animate
    
    var items: [InheritItem] {
        switch self {
        case .view:
            return [.colorButton, .collectionview, .hud, .actionsheet, .guide, .monitor, .popupMenu, .segment, .wave, .progress, .scan, .scene, .textview, .textfield]
        case .controller:
            return [.image]
        case .animate:
            return [.group, .sequence]
        }
    }
}
