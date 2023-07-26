//
//  CropViewController.swift
//  Example
//
//  Created ghost on 2023/7/26.
//

import UIKit
import ThenUIKit

final class CropViewController: UIViewController, CropViewProtocol {

	var presenter: CropPresenterProtocol?

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        title = "裁剪 比较"
    }
    
    /// 两种裁剪效果基本一致,
    /// cropped可以避免图像失真或者出现锯齿等情况
    /// 性能方面都采用cgimage.cropped, 基本无差异
    @IBAction func cropClick(_ sender: Any) {
        guard let image = UIImage(named: "pexels-2") else { return }
        let rect = CGRect(width: 2000, height: 2000)
        imageView.image = image.cropped_T(to: rect)
    }
    
    @IBAction func cropClick2(_ sender: Any) {
        guard let image = UIImage(named: "pexels-2") else { return }
        let rect = CGRect(width: 2000, height: 2000)
        imageView.image = image.cropped(to: rect)
    }
    
}

extension UIImage {
    
    fileprivate func cropped_T(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width && rect.size.height <= size.height else {
            return self
        }
        guard let image: CGImage = cgImage?.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: image)
    }
    
}
