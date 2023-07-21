//
//  ThenSectionDecorationView.swift
//  ThenUIKit
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit

final internal class ThenSectionDecorationView: UICollectionReusableView {
    
    static let identifier = "com.then.uikit.section.decoration.identifier"
    
    // 新建UIImageView
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attributes = layoutAttributes as? ThenSectionLayoutAttributes else {
            return
        }
        imageView.frame = attributes.bounds
        
        if let cornerRadius = attributes.cornerRadius {
            imageView.layer.cornerRadius = cornerRadius
        } else {
            imageView.layer.cornerRadius = 0
        }
        imageView.backgroundColor = attributes.backgroundColor
        //
        imageView.image = attributes.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
