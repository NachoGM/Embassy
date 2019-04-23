//
//  VCExtensions.swift
//  Embassy
//
//  Created by Nacho González Miró on 29/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    // MARK: Display Alert
    func showInformativeErrorMessage(title: String = NSLocalizedString("Atención", comment: ""), message: String, then completion: @escaping(() -> (Void)) = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Entendido", comment: ""), style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
    // MARK: Hide Keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Date Formatter
    func dateToString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    // MARK: Handle Custom Alert Dialog
    func setBlurBg(blurImage:UIImageView) {
        for subview in blurImage.subviews {
            subview.removeFromSuperview()
        }
        let blurEffect = UIBlurEffect(style: .dark)
        let viewBlur = UIVisualEffectView(effect: blurEffect)
        blurImage.layoutIfNeeded()
        viewBlur.frame = blurImage.bounds
        blurImage.addSubview(viewBlur)
    }
    
    func setBaseAlert(baseAlert:UIView) {
        baseAlert.layer.cornerRadius = 15
        baseAlert.layer.masksToBounds = false
        baseAlert.layer.shadowColor = UIColor.darkGray.cgColor
        baseAlert.layer.shadowOffset = CGSize(width: 0, height: 3)
        baseAlert.layer.shadowOpacity = Float(0.5)
    }
    
    // MARK: Handle keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Menu Btn
    func displayMenuBtn(button:UIBarButtonItem) {
        if revealViewController() != nil {
            button.target = self.revealViewController()
            button.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.revealViewController()?.rearViewRevealWidth = 3 * (self.view.frame.size.width / 4)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK: - Set initial VC
    func handleRootVC(storyboard name:String, identifier:String) {
        let window = UIApplication.shared.windows.first
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: identifier)
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    // MARK: - ImagePicker
    //MARK: Open the camera
    func openCamera(imagePicker:UIImagePickerController, delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = delegate
            present(imagePicker, animated: true, completion: nil)
        } else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Choose image from camera roll
    func openGallary(imagePicker:UIImagePickerController, delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = delegate
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImageOptionsDialog(imagePicker:UIImagePickerController, delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera(imagePicker: imagePicker, delegate: delegate)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary(imagePicker: imagePicker, delegate: delegate)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
