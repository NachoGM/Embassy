//
//  ProfileVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var addNewUserImg: UIButton!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var serviceObj = ServiceObject()
    var serviceDb = ServiceDataBase()
    var profileList = [ProfileObject]()
    var imagePicker = UIImagePickerController()
    var childScrollView: UIScrollView { return tableView }

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleHeader.isHidden = true
        setTableView()
        setHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Profile VC")
        
        setProfileData()
        setProfileList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let offset = tableViewTopConstraint.constant - childScrollView.contentOffset.y
        if (offset < 80) {
            return .default
        } else {
            return .lightContent
        }
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
    }
    
    func setHeaderView() {
        headerView.backgroundColor = .clear
        self.menuBtn.isHidden = true
        self.moreInfoBtn.isHidden = true
    }
    
    func setProfileData() {
        if let profile = serviceDb.loadUserProfile().last {
            self.userImg.image = UIImage(data: profile.image! as Data)
        }
        
        guard let profile = serviceDb.loadUserProfile().last else { return }
        self.userNameLb.text = profile.name
        
        self.addNewUserImg.layer.cornerRadius = self.addNewUserImg.frame.size.height / 2
        self.addNewUserImg.setImage(UIImage(named: "camera"), for: .normal)
    }
    
    func setProfileList() {
        profileList = serviceObj.loadUserInfo()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addNewPhoto(_ sender: Any) {
        showImageOptionsDialog(imagePicker: self.imagePicker, delegate: self)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        comeBackToHomeVC()
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        showInformativeErrorMessage(message: "Esta funcionalidad está bloqueada. \n\n Para acceder a ella debes de invitar a una cerveza al desarrollador")
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        comeBackToHomeVC()
    }
    
    func comeBackToHomeVC() {
        let destinationVC = self.storyboard!.instantiateViewController(withIdentifier: "reveal")
        self.revealViewController()?.pushFrontViewController(destinationVC, animated: true)
    }
}

// MARK: - TableView
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCell
        let item = profileList[indexPath.row]
        cell.setProfileCell(object: item)
        return cell
    }
}

extension ProfileVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let imageViewHeight: CGFloat = 300
        
        let scrollingUp = childScrollView.contentOffset.y > 0
        
        // 80 is the height of the navbar*
        if scrollingUp && tableViewTopConstraint.constant > 80 {
            var offset = tableViewTopConstraint.constant - childScrollView.contentOffset.y
            let imgOffset = imageViewTopConstraint.constant - (childScrollView.contentOffset.y / 2)
            
            // Catch if it surpasses navigation bar height
            if (offset < 80) {
                offset = 80
                UIView.animate(withDuration: 0.3, animations: {
                    self.headerView.backgroundColor = .white
                    self.titleHeader.isHidden = false
                    self.titleHeader.text = self.userNameLb.text
                    self.userNameLb.isHidden = true
                    self.backBtn.isHidden = true 
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
            
            tableViewTopConstraint.constant = offset
            
        } else if (!scrollingUp && tableViewTopConstraint.constant < imageViewHeight){
            var offset = tableViewTopConstraint.constant + abs(childScrollView.contentOffset.y)
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
                    self.backBtn.isHidden = false
                    self.userNameLb.isHidden = false
                })
            }
            
            tableViewTopConstraint.constant = offset
            imageViewTopConstraint.constant = imgOffset
        }
    }
}

extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userImg.image = editedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
