//
//  RackImagePickerViewController.swift
//  Alerts&Pickers
//
//  Created by Andreas Juen on 09.01.23.
//  Copyright © 2023 Supreme Apps. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Add Locale Picker
    ///
    /// - Parameters:
    ///   - type: country, phoneCode or currency
    ///   - action: for selected locale
    
    public func addRackImagePicker(presentationController: UIViewController, action: RackImagePicker.SelectedImageAction?) {
        _ = RackImagePicker(alertController: self, presentationController: presentationController, action: action)
    }
}

public protocol RackImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

final public class RackImagePicker: NSObject {
    private var alertController: UIAlertController
    private lazy var pickerController: UIImagePickerController = { [unowned self] in
        return $0
    }(UIImagePickerController())
    private weak var presentationController: UIViewController?
    fileprivate var selectedImageAction: SelectedImageAction?
    
    public typealias SelectedImageAction = (_ image: UIImage?) -> ()
    
    public init(alertController: UIAlertController, presentationController: UIViewController, action: SelectedImageAction?) {
        self.presentationController = presentationController
        self.selectedImageAction = action
        self.alertController = alertController
        super.init()
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.modalPresentationStyle = .fullScreen
        self.pickerController.mediaTypes = ["public.image"]
        initAction()
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default, handler: { (alertAction) in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        })
    }
    
    public func initAction() {
        if let action = self.action(for: .camera, title: NSLocalizedString("takePhoto", comment: "")) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: NSLocalizedString("photoLibrary", comment: "")) {
            alertController.addAction(action)
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        selectedImageAction?(image)
    }
}

extension RackImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension RackImagePicker: UINavigationControllerDelegate {
    
}

