//
//  ThenControllerView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/7/21.
//

import UIKit
#if canImport(swiftUI)
import SwiftUI

/// UIViewControllerRepresentable，用于在 SwiftUI 中显示 UIViewController
/// SwiftUI中使用示例: ThenControllerView<UIViewController>()
struct ThenControllerView<T: UIViewController>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = T
    
    func makeUIViewController(context: Context) -> T {
        return T()
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
}

#endif
