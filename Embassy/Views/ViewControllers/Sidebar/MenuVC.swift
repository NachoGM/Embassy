//
//  MenuVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    
    var serviceDb = ServiceDataBase()
    var serviceObj = ServiceObject()
    var menuList = [SidebarObject]()
    var isAccountBtnSelected = false
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Menu VC")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableViewTrailingConstraint.constant = (-self.revealViewController()!.rearViewRevealWidth / 4) + 30.0
        tableView.layoutIfNeeded()
        tableView.layoutSubviews()
    }

    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Extensions
extension MenuVC: UITableViewDataSource {
    enum Sections: Int {
        case Profile
        case Settings
        case Embassy
        case Extra
        case Logout
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isAccountBtnSelected {
            return 5
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isAccountBtnSelected {
            switch section {
            case Sections.Profile.rawValue:
                return 1
            case Sections.Settings.rawValue:
                return serviceObj.setSettings().count
            case Sections.Embassy.rawValue:
                return serviceObj.setEmbassyList().count
            case Sections.Extra.rawValue:
                return serviceObj.setExtraList().count
            case Sections.Logout.rawValue:
                return serviceObj.setLogout().count
            default:
                return 1
            }
        } else {
            switch section {
            case Sections.Profile.rawValue:
                return 1
            case Sections.Settings.rawValue:
                return serviceObj.setAccountList().count
            default:
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.Profile.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountCell
            return setProfileCell(cell: cell, indexPath: indexPath)
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
            var items : SidebarObject!
            if !isAccountBtnSelected {
                switch indexPath.section {
                case Sections.Settings.rawValue:
                    items = serviceObj.setSettings()[indexPath.row]
                case Sections.Embassy.rawValue:
                    items = serviceObj.setEmbassyList()[indexPath.row]
                case Sections.Extra.rawValue:
                    items = serviceObj.setExtraList()[indexPath.row]
                case Sections.Logout.rawValue:
                    items = serviceObj.setLogout()[indexPath.row]
                default:
                    break
                }
                cell.setMenuCell(object: items)
                return cell
                
            } else {
                switch indexPath.section {
                case Sections.Profile.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountCell
                    return setProfileCell(cell: cell, indexPath: indexPath)
                case Sections.Settings.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
                    return setAccountCell(cell: cell, indexPath: indexPath)
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountCell
                    return setProfileCell(cell: cell, indexPath: indexPath)
                }
            }
        }
    }
    
    // MARK: Cells
    func setAccountCell(cell: MenuCell, indexPath: IndexPath) -> MenuCell {
        let items = serviceObj.setAccountList()[indexPath.row]
        cell.setMenuCell(object: items)
        return cell
    }
    
    func setProfileCell(cell: AccountCell, indexPath: IndexPath) -> AccountCell {
        let items = serviceDb.loadUserProfile()[indexPath.row]
        cell.setUserProfileCell(object: items, isAccountBtnSelected:isAccountBtnSelected)
        cell.accountSettingsBtn.addTarget(self, action: #selector(accountTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func accountTapped(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            NSLog("Account Btn is selected")
            isAccountBtnSelected = true
        } else {
            NSLog("Account Btn is selected")
            isAccountBtnSelected = false
        }
        tableView.reloadData()
    }
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if !isAccountBtnSelected {
            if indexPath.section != Sections.Profile.rawValue {
                switch indexPath.section {
                case Sections.Settings.rawValue:
                    pushToVC(navIdentifier: "settingsNC", segueIdentifier: "settings")
                    break
                case Sections.Embassy.rawValue:
                    let itemList = serviceObj.setEmbassyList()[indexPath.row]
                    if itemList.name.contains("Embajadas") {
                        NSLog("You tapped in \(itemList.name!)")
                        let destinationVC = self.storyboard!.instantiateViewController(withIdentifier: "reveal")
                        self.revealViewController()?.pushFrontViewController(destinationVC, animated: true)
                    } else if itemList.name.contains("recientes") {
                        pushToVC(navIdentifier: "mostViewedNC", segueIdentifier: "searched")
                    } else if itemList.name.contains("Extra") {
                        pushToVC(navIdentifier: "underConstructionNC", segueIdentifier: "underConstruction")
                    } else {
                        NSLog("Error seleccionando celda en Sección 2")
                    }
                    break
                case Sections.Extra.rawValue:
                    let itemList = serviceObj.setExtraList()[indexPath.row]
                    NSLog("You tapped in \(itemList.name!)")
                    showInformativeErrorMessage(message: "La sección \(itemList.name!) no está disponible con la versión demo. \n\n Invíte al desarrollador a una ceveza e intentalo de nuevo")
                    break
                case Sections.Logout.rawValue:
                    let itemList = serviceObj.setLogout()[indexPath.row]
                    NSLog("Tapped in \(itemList.name!)")
                    serviceDb.saveInUserDefaults(isLoggedIn: false, forKey: "isUserLoggedIn")
                    handleRootVC(storyboard: "Login", identifier: "signin")
                    break
                default:
                    break
                }
            } else {
                NSLog("You tapped in User Profile Cell")
            }
        } else {
            if indexPath.section != Sections.Profile.rawValue {
                let itemList = serviceObj.setAccountList()[indexPath.row]
                var navIdentifier = ""
                var segueIdentifier = ""
                let user = serviceDb.loadUserProfile().last!
                guard let email = user.email else { return }
                guard let name = itemList.name else { return }
                
                if name == email {
                    showInformativeErrorMessage(message: "Este es tu email: \(email). /n/n Para habilitar esta funcionalidad debes de invitar a una cerveza al desarrollador")
                } else if name.contains("Añadir") {
                    navIdentifier = "newAccountNC"
                    segueIdentifier = "newAccount"
                } else if name.contains("Administrar") {
                    navIdentifier = "profileNC"
                    segueIdentifier = "profile"
                } else {
                    NSLog("Error cuando has seleccionado la celda \(name)")
                }
                
                NSLog("You tapped in \(itemList.name!)")
                pushToVC(navIdentifier: navIdentifier, segueIdentifier: segueIdentifier)
            } else {
                NSLog("You tapped in User Profile Cell")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Sections.Profile.rawValue {
            return 280.0
        } else {
            return 60.0
        }
    }
    
    // MARK: Methods used in tableView Delegate
    func pushToVC(navIdentifier:String, segueIdentifier:String) {
        let navCtr = self.storyboard?.instantiateViewController(withIdentifier:navIdentifier) as! UINavigationController
        let segue = SWRevealViewControllerSeguePushController.init(identifier:segueIdentifier, source: self, destination: navCtr)
        segue.perform()
    }
}
