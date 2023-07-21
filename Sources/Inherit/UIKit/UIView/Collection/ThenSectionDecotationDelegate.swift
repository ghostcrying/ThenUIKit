//
//  ThenSectionDecotationDelegate.swift
//  ThenUIKit
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit

public enum ThenSectionDecorationType {
    /// Cell + Header + Footer
    case `default`
    /// Cell
    case center
    /// Cell + Header
    case topCenter
    /// Cell + Footer
    case bottomCenter
}

public protocol ThenSectionDecorationDelegate: NSObjectProtocol {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundColorForSectionAt section: Int) -> UIColor?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundImageForSectionAt section: Int) -> UIImage?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, cornerRadiusForSectionAt section: Int) -> CGFloat?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, headerForSectionAt section: Int) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, footerForSectionAt section: Int) -> CGSize
    
    /// 设置Section背景的Inset，原始Section固定, 调整背景位置
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, marginForSectionAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, decorationTypeForSectionAt section: Int) -> ThenSectionDecorationType
}

public extension ThenSectionDecorationDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundColorForSectionAt section: Int) -> UIColor? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundImageForSectionAt section: Int) -> UIImage? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, cornerRadiusForSectionAt section: Int) -> CGFloat? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, headerForSectionAt section: Int) -> CGSize {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, footerForSectionAt section: Int) -> CGSize {
        .zero
    }
    
    /// 设置Section背景的Inset，原始Section固定, 调整背景位置
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, marginForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, decorationTypeForSectionAt section: Int) -> ThenSectionDecorationType {
        return .default
    }
}

