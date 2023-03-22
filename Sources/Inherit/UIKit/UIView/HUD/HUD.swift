//
//  HUD.swift
//  ThenUIKit
//
//  Created by 陈卓 on 2023/3/6.
//

import UIKit

public struct HUD {
    
    static public func show(text: String?) {
        guard let message = text, !message.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            guard let view = UIApplication.shared.window else {
                return
            }
            // hide
            ThenProgressHUD.hide(view)
            //
            let hud = ThenProgressHUD.show(parent: view, style: .text(position: .center))
            hud?.title = message
            hud?.show(duration: (message.count > 20) ? 6 : 3, animate: true)
        }
    }
    
    static public func showActivity(_ parent: UIView? = nil) {
        DispatchQueue.main.async {
            ThenProgressHUD.show(parent: parent, style: .indeterminate)?.show()
        }
    }
    
    static public func hideActivity(_ parent: UIView? = nil) {
        DispatchQueue.main.async {
            ThenProgressHUD.hudfor(parent)?.hide()
        }
    }
}
