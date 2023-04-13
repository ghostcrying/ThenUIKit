//
//  ThenAlbumPicker.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/1.
//

import UIKit

public extension ThenAlbumPicker {
    
    /// 图片编辑类型
    enum ClipStyle {
        /// 原始图片
        case none
        /// 正方形裁剪
        case square
        /// 圆形
        case circle
    }
}

// MARK: - 相册/相机 图片选择
public class ThenAlbumPicker: NSObject {

    public static let shared = ThenAlbumPicker()
    
    private var closure: ((UIImage?) -> ())?
    /// 是否允许圆形裁剪
    private var style: ClipStyle = .none
    
    /// 读取相册照片不需要权限
    /// - isCircleClip: 是否允许裁剪
    public func photolibrary(_ controller: UIViewController, style: ClipStyle = .none, closure: @escaping ((UIImage?) -> ())) {
        self.closure = closure
        self.style = style
        DispatchQueue.main.async {
            /*
             // 暂时不用适配14系统的
             if #available(iOS 14.0, *) {
                 var config = PHPickerConfiguration()
                 config.selectionLimit = 1
                 config.filter = .images
                 
                 let picker = PHPickerViewController(configuration: config)
                 picker.delegate = self
                 picker.isEditing = false
                 picker.modalPresentationStyle = .overFullScreen
                 controller.present(picker, animated: true, completion: nil)
             } else {
                 let picker = UIImagePickerController()
                 picker.sourceType = .photoLibrary
                 picker.modalPresentationStyle = .overFullScreen
                 picker.allowsEditing = false // 不编辑
                 picker.delegate = self
                 controller.present(picker, animated: true, completion: nil)
             }
             */
            let picker = PickerController()
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .overFullScreen
            picker.allowsEditing = false // 不编辑
            picker.delegate = self
            controller.present(picker, animated: true)
        }
    }
    
    /// 需要先判定相机权限
    public func photoCamera(_ controller: UIViewController, style: ClipStyle = .none, closure: @escaping ((UIImage?) -> ())) {
        DispatchQueue.main.async {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            let devices: [UIImagePickerController.CameraDevice] = [.rear, .front]
            guard let availableDevice = devices.filter({ UIImagePickerController.isCameraDeviceAvailable($0) }).first else {
                return
            }
            self.closure = closure
            self.style = style
            let pickerVC = PickerController()
            pickerVC.sourceType = .camera
            pickerVC.cameraDevice = availableDevice
            pickerVC.allowsEditing = false // 不编辑
            pickerVC.showsCameraControls = true
            pickerVC.delegate = self
            controller.present(pickerVC, animated: true) { }
        }
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ThenAlbumPicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true) { self.closure?(nil) }
            return
        }
        guard self.style != .none else {
            picker.dismiss(animated: true) { self.closure?(originImage) }
            return
        }
        guard let controller = picker as? PickerController else {
            picker.dismiss(animated: true) { self.closure?(nil) }
            return
        }
        // deal custom clip
        controller.startEditer(image: originImage, clipState: self.style) { [weak self] value in
            switch value {
            case .cancel:
                controller.dismiss(animated: true)
            case .sure(let image):
                controller.dismiss(animated: true) {
                    self?.closure?(image)
                }
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension ThenAlbumPicker {
    
    internal class PickerController: UIImagePickerController {

        lazy var editView: ThenAlbumEditView = {
            let view = ThenAlbumEditView(frame: .zero)
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.addSubview(self.editView)
            NSLayoutConstraint.activate([
                self.editView.leftAnchor.constraint(equalTo: view.leftAnchor),
                self.editView.rightAnchor.constraint(equalTo: view.rightAnchor),
                self.editView.topAnchor.constraint(equalTo: view.topAnchor),
                self.editView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
                
        func startEditer(image: UIImage, clipState: ThenAlbumPicker.ClipStyle, closure: @escaping (ThenAlbumEditView.PickerType) -> ()) {
            editView.configUI(image: image, clipState: clipState, clickClosure: closure)
            editView.isHidden = false
        }
    }

}
