//
//  ThenInputSecrectImageView.swift
//  Test_02
//
//  Created by 陈卓 on 2023/2/24.
//

import UIKit

public class ThenInputSecrectImageView: UIView {
    
    //MARK: - Public
    public var imageWidths: CGFloat = 24 {
        didSet {
            guard imageWidths != oldValue else { return }
            self.widthsConstrant.constant = imageWidths
        }
    }
    
    public var imageHeight: CGFloat = 24 {
        didSet {
            guard imageHeight != oldValue else { return }
            self.heightConstrant.constant = imageHeight
        }
    }
    
    public var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    //MARK: - Private
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private var widthsConstrant: NSLayoutConstraint!
    
    private var heightConstrant: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.widthsConstrant = self.imageView.widthAnchor.constraint(equalToConstant: imageWidths)
        self.widthsConstrant.isActive = true
        self.heightConstrant = self.imageView.heightAnchor.constraint(equalToConstant: imageHeight)
        self.heightConstrant.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

