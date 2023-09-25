//
//  UIView+Event.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/17.
//

import UIKit

private enum StaticsPointKey {
    @UniqueAddress static var point
    @UniqueAddress static var param
}

public extension ViewableType {
    /// 统计节点
    var staticsPoint: String? {
        get { objc_getAssociatedObject(self, StaticsPointKey.point) as? String }
        set { objc_setAssociatedObject(self, StaticsPointKey.point, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 参数
    var staticsParams: [AnyHashable: Any]? {
        get { objc_getAssociatedObject(self, StaticsPointKey.param) as? [AnyHashable: Any] }
        set { objc_setAssociatedObject(self, StaticsPointKey.param, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 设定上报参数
    func configStatics(point: String? = nil, params: [AnyHashable: Any]? = nil) {
        staticsPoint = point
        staticsParams = params
    }
}
