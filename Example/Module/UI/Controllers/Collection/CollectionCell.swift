//
//  CollectionCell.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    static let identifier = "com.then.uikit.example.collection.cell.identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.lightGray
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionSectionFooter: UICollectionReusableView {
        
    static let identifier = "com.then.uikit.example.collection.footer.identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 40))
        label.text = "This Is Section Footer"
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CollectionSectionHeader: UICollectionReusableView {
        
    static let identifier = "com.then.uikit.example.collection.header.identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 40))
        label.text = "This Is Section Header"
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
