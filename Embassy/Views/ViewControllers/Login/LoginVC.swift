//
//  LoginVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var blurImg: UIImageView!
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var userPassTf: UITextField!
    
    var serviceDb = ServiceDataBase()
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUserTf()
        setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Login VC")
        setBlurBg(blurImage: blurImg)
        user = serviceDb.loadUserProfile().last
    }
    
    func setUserTf() {
        let userList = serviceDb.loadUserProfile()
        self.userNameTf.text = userList.last?.name ?? "Todavía no te has registrado"
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - IBActions
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if !self.userNameTf.text!.isEmpty {
            if !self.userPassTf.text!.isEmpty {
                if userNameTf.text == user?.name {
                    if userPassTf.text == user?.password {
                        self.view.endEditing(true)
                        
                        serviceDb.saveInUserDefaults(isLoggedIn: true, forKey: "isUserLoggedIn")
                        handleRootVC(storyboard: "Main", identifier: "reveal")
                    } else {
                        showInformativeErrorMessage(message: "Por favor, introduce una contraseña válida e inténtalo de nuevo")
                    }
                } else {
                    showInformativeErrorMessage(message: "Por favor, introduce un usuario válido e inténtalo de nuevo")
                }
            } else {
                showInformativeErrorMessage(message: "Este campo no puede introducirse vacío. /n/n Por favor, introduce una contraseña e inténtalo de nuevo.")
            }
        } else {
            showInformativeErrorMessage(message: "Este campo no puede introducirse vacío. /n/n Por favor, introduce un usuario e inténtalo de nuevo")
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
