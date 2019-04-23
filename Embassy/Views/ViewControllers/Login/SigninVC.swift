//
//  SigninVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class SigninVC: UIViewController {

    @IBOutlet weak var blurImg: UIImageView!
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passTf: UITextField!
    @IBOutlet weak var fullNameTf: UITextField!
    @IBOutlet weak var companyTf: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    var serviceDb = ServiceDataBase()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewStyles()
        setTextFieldDelegate()
        setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Signin VC")
        setBlurBg(blurImage: blurImg)
    }

    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initViewStyles() {
        profileView.layer.cornerRadius = profileView.frame.height / 2
        userImg.layer.cornerRadius = userImg.frame.height / 2
        addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.height / 2
    }
    
    func setTextFieldDelegate() {
        let textFieldList : [UITextField] = [userNameTf, emailTf, passTf, fullNameTf, companyTf]
        for tf in textFieldList {
            tf.delegate = self
        }
    }
    
    // MARK: - IBActions
    @IBAction func chooseImageTapped(_ sender: UIButton) {
        showImageOptionsDialog(imagePicker: self.imagePicker, delegate: self)
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        guard let userName = userNameTf.text else { return }
        guard let password = passTf.text else { return }
        guard let userEmail = emailTf.text else { return }
        guard let company = companyTf.text else { return }
        guard let image = userImg.image else { return }
        
        if !userName.isEmpty {
            if !userEmail.isEmpty {
                serviceDb.saveUser(image: image.pngData()!, name: userName, phone: "", email: userEmail, password: password ,address: "", company: company)
                
                checkIfUserExistAndGoesToLoginVC()

            } else {
                showInformativeErrorMessage(message: "Debes de introducir el email")
            }
        } else {
            showInformativeErrorMessage(message: "Debes de introducir el nombre de usuario")
        }        
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        checkIfUserExistAndGoesToLoginVC()
    }
    
    func checkIfUserExistAndGoesToLoginVC() {

        let user = serviceDb.loadUserProfile().last
        
        var userToSend : Any?
        if user != nil {
            userToSend = user
        } else {
            userToSend = nil
        }
        self.performSegue(withIdentifier: "loginSegue", sender: userToSend)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationVC = segue.destination as! LoginVC
            destinationVC.user = sender as? User
        }
    }
}

// MARK: - Extensions
extension SigninVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SigninVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userImg.image = editedImage
            self.addPhotoBtn.setImage(UIImage(named: "camera"), for: .normal)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
