//
//  CreateNewAccountVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 10/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import TextFieldEffects

class CreateNewAccountVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewtopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var addNewImg: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    
    var serviceObj = ServiceObject()
    var newAccountList = [NewAccountObject]()
    var imagePicker = UIImagePickerController()
    var childScrollView: UIScrollView { return tableView }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setHeaderView()
        loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Create New Account VC")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let offset = tableViewtopConstraint.constant - childScrollView.contentOffset.y
        if (offset < 80) {
            return .default
        } else {
            return .lightContent
        }
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        addNewImg.layer.cornerRadius = addNewImg.frame.size.height / 2
    }
    
    func setHeaderView() {
        headerView.backgroundColor = .clear
        self.titleHeader.text = ""
        self.menuBtn.isHidden = true
        self.moreInfoBtn.isHidden = true
    }

    func loadInitialData() {
        newAccountList = serviceObj.setNewAccountData()
        tableView.reloadData()
    }
    
    // MARK: IBActions
    @IBAction func addNewImgTapped(_ sender: Any) {
        showImageOptionsDialog(imagePicker: self.imagePicker, delegate: self)
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        showInformativeErrorMessage(message: "Esta funcionalidad está bloqueada. \n\n Debes de invitar a una cerveza al desarrollador")
    }
    
    @IBAction func menuBtnTapped(_ sender: Any) {
        comeBackToHomeVC()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        comeBackToHomeVC()
    }
    
    func comeBackToHomeVC() {
        let destinationVC = self.storyboard!.instantiateViewController(withIdentifier: "reveal")
        self.revealViewController()?.pushFrontViewController(destinationVC, animated: true)
    }
}

// MARK: - TableView
extension CreateNewAccountVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newAccountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newAccountCell") as! NewAccountCell
        let item = newAccountList[indexPath.row]
        cell.setNewAccountCell(object: item)
        return cell
    }
}

extension CreateNewAccountVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let imageViewHeight: CGFloat = 300
        
        let scrollingUp = childScrollView.contentOffset.y > 0
        
        // 80 is the height of the navbar*
        if scrollingUp && tableViewtopConstraint.constant > 80 {
            var offset = tableViewtopConstraint.constant - childScrollView.contentOffset.y
            let imgOffset = imageViewTopConstraint.constant - (childScrollView.contentOffset.y / 2)
            
            // Catch if it surpasses navigation bar height
            if (offset < 80) {
                offset = 80
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerView.backgroundColor = .white
                    self.titleHeader.isHidden = false
                })
                
                setNeedsStatusBarAppearanceUpdate()
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleHeader.isHidden = false
                    self.menuBtn.isHidden = false
                    self.moreInfoBtn.isHidden = false
                    self.imageViewTopConstraint.constant = imgOffset
                })
            }
            
            tableViewtopConstraint.constant = offset
            
        } else if (!scrollingUp && tableViewtopConstraint.constant < imageViewHeight){
            var offset = tableViewtopConstraint.constant + abs(childScrollView.contentOffset.y)
            var imgOffset = imageViewTopConstraint.constant + (abs(childScrollView.contentOffset.y) / 2)
            
            // Catch if it surpasses original table view position
            if (offset > imageViewHeight) {
                offset = imageViewHeight
                imgOffset = 0
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerView.backgroundColor = .clear
                    self.menuBtn.isHidden = true
                    self.moreInfoBtn.isHidden = true
                    self.titleHeader.isHidden = true
                })
            }
            
            tableViewtopConstraint.constant = offset
            imageViewTopConstraint.constant = imgOffset
        }
    }
}

// MARK: - ImagePicker
extension CreateNewAccountVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userImg.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
