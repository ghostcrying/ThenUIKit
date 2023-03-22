//
//  UIView+Event.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/17.
//

import UIKit

fileprivate var KUIViewStaticsPointKey  = "com.then.statistis.point.key"
fileprivate var KUIViewStaticsParamKey  = "com.then.statistis.param.key"

public extension ViewableType {
    /// 统计节点
    var staticsPoint: String? {
        get { return objc_getAssociatedObject(self, &KUIViewStaticsPointKey) as? String }
        set { objc_setAssociatedObject(self, &KUIViewStaticsPointKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 参数
    var staticsParams: [AnyHashable: Any]? {
        get { return objc_getAssociatedObject(self, &KUIViewStaticsParamKey) as? [AnyHashable: Any] }
        set { objc_setAssociatedObject(self, &KUIViewStaticsParamKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 设定上报参数
    func configStatics(point: String? = nil, params: [AnyHashable: Any]? = nil) {
        self.staticsPoint = point
        self.staticsParams = params
    }

}

