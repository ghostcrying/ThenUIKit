//
//  ThenAlbumPicker.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/1.
//

import UIKit

public extension ThenAlbumPicker {
    
    enum ClipStyle {
        /// 不裁剪
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
            let picker = UIImagePickerController()
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
            let pickerVC = UIImagePickerController()
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
        // 在这里进入自定义裁剪页面
        let editView = ThenAlbumEditView(frame: UIScreen.main.bounds, style: self.style)
        editView.configUI(originImage)
        editView.clickClosure = { [weak self] value in
            switch value {
            case .cancel:
                picker.dismiss(animated: true)
            case .sure(let image):
                picker.dismiss(animated: true) {
                    self?.closure?(image)
                }
            }
        }
        picker.view.addSubview(editView)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
