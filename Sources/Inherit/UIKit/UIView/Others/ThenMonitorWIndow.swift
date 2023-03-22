//
//  ThenMonitorWindow.swift
//  ThenUIKit
//
//  Created by ghost on 2020/5/6.
//

import UIKit

public class ThenMonitorWindow: UIWindow {
    
    public var eventHandle: ((_ event: UIEvent) -> Void)?
    
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        eventHandle?(event)
    }
}
