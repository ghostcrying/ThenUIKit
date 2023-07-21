//
//  CollectionController.swift
//  Example
//
//  Created by 陈卓 on 2023/7/21.
//

import UIKit
import ThenUIKit
import ThenFoundation

class CollectionController: UIViewController {

    lazy var collectionView: UICollectionView = {
        
        let kWidth  = UIScreen.main.bounds.width
        let kHeight = UIScreen.main.bounds.height
        
        let itemW: CGFloat = (kWidth-70)*0.25
        let itemH: CGFloat = itemW
        let layout = ThenSectionDecorationFlowLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.delegate = self
        collection.dataSource = self
        
        collection.alwaysBounceVertical = true
        collection.dragInteractionEnabled = true
        
        collection.register(CollectionSectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionSectionFooter.identifier)
        collection.register(CollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionHeader.identifier)
        collection.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)

        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Section Background"
        view.backgroundColor = UIColor.systemGroupedBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
        
    }
    
}

extension CollectionController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionHeader.identifier, for: indexPath)
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionFooter.identifier, for: indexPath)
        }
    }
    
}

extension CollectionController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 100, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 100, height: 40)
    }
    
}

extension CollectionController: ThenSectionDecorationDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundColorForSectionAt section: Int) -> UIColor? {
        .white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, backgroundImageForSectionAt section: Int) -> UIImage? {
        nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, cornerRadiusForSectionAt section: Int) -> CGFloat? {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, footerForSectionAt section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, headerForSectionAt section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, marginForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ThenSectionDecorationFlowLayout, decorationTypeForSectionAt section: Int) -> ThenUIKit.ThenSectionDecorationType {
        return .default
    }
    
}
