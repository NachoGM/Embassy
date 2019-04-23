//
//  ServiceObject.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation

class ServiceObject {
    
    var serviceDb = ServiceDataBase()
    
    // MARK: - Menú lateral
    func setAccountList() -> [SidebarObject] {
        let user = serviceDb.loadUserProfile().last!
        let account = SidebarObject(with: user.email!, icon: "user", hasDetail: false, detailNum: "", detailColor: .clear)
        let addAccount = SidebarObject(with: "Añadir cuenta", icon: "add", hasDetail: false, detailNum: "", detailColor: .clear)
        let manageAccount = SidebarObject(with: "Administrar cuentas", icon: "manageAccount", hasDetail: false, detailNum: "", detailColor: .clear)
        return [account, addAccount, manageAccount]
    }
    
    func setEmbassyList() -> [SidebarObject] {
        let allEmbassy = serviceDb.loadEmbassy(isSearched: false).count
        let embassySearched = serviceDb.loadEmbassy(isSearched: true).count
        
        let embassyAndCouncils = SidebarObject(with: "Embajadas y Consulados", icon: "ic_embassy", hasDetail: true, detailNum: "\(allEmbassy)", detailColor: .red)
        let embassyViewed = SidebarObject(with: "Búsquedas recientes", icon: "ic_search", hasDetail: true, detailNum: "\(embassySearched)", detailColor: .orange)
        let extraItem = SidebarObject(with: "Extra", icon: "ic_extra", hasDetail: true, detailNum: "1", detailColor: .purple)
        return [embassyAndCouncils, embassyViewed, extraItem]
    }
    
    func setExtraList() -> [SidebarObject] {
        let starred = SidebarObject(with: "Favoritos", icon: "ic_starred", hasDetail: false, detailNum: "", detailColor: .clear)
        let sent = SidebarObject(with: "Enviados", icon: "ic_sent", hasDetail: false, detailNum: "4", detailColor: .clear)
        let spam = SidebarObject(with: "Spam", icon: "ic_spam", hasDetail: true, detailNum: "1", detailColor: .green)
        let trash = SidebarObject(with: "Basura", icon: "ic_trash", hasDetail: false, detailNum: "", detailColor: .clear)
        return [starred, sent, spam, trash]
    }
    
    func setSettings() -> [SidebarObject] {
        let settings = SidebarObject(with: "Ajustes", icon: "ic_settings", hasDetail: false, detailNum: "", detailColor: .clear)
        return [settings]
    }
    
    func setLogout() -> [SidebarObject] {
        let logout = SidebarObject(with: "Logout", icon: "ic_logout", hasDetail: false, detailNum: "", detailColor: .clear)
        return [logout]
    }
    
    // MARK: - User
    func loadUserInfo() -> [ProfileObject] {
        let loremIpsumString = "Lorem ipsum dolor sit amet consectetur adipiscing, elit taciti montes litora nec porta, euismod rutrum ac est facilisis. Ornare quam torquent nostra tempus suscipit sed, sociosqu eros quis class pulvinar, ullamcorper laoreet nulla porttitor commodo. Diam quam taciti sapien dui netus accumsan sagittis varius, porta odio at luctus nullam feugiat nam et massa, placerat fames morbi mauris lacus montes urna. \n\n Vitae orci dictum ullamcorper auctor magna parturient, mollis aenean feugiat fermentum mauris risus taciti, commodo tincidunt eget mus urna. Enim eros ullamcorper posuere montes duis vehicula sed mi congue urna, vitae dapibus dui nisl sociosqu ligula velit nullam aptent habitasse, diam a torquent rhoncus lectus neque primis pulvinar nisi. Interdum tristique sollicitudin non nisl diam fringilla, rhoncus sociis rutrum quisque odio, eu mi hac fusce a."
        let imageList:[UIImage] = [UIImage(named: "bg")!, UIImage(named: "bg1")!, UIImage(named: "bg2")!, UIImage(named: "bg3")!]
        
        let aboutMe = ProfileObject(with: "Sobre mi", description: loremIpsumString, imageString: "user2", userImageList: [])
        let hobbies = ProfileObject(with: "Hobbies", description: "Lorem ipsum dolor sit amet consectetur adipiscing, elit taciti montes litora nec porta, euismod rutrum ac est facilisis.", imageString: "hobbies", userImageList: [])
        let photos = ProfileObject(with: "Photos", description: "", imageString: "camera2", userImageList: imageList)
        
        return [aboutMe, hobbies, photos]
    }
    
    func updateUserInfo(updatedText:String) -> [ProfileObject] {
        let userInfo = loadUserInfo().last
        var updatedInfo = [ProfileObject]()
        
        if !userInfo!.description.contains(updatedText) {
            userInfo?.description = updatedText
            updatedInfo = [userInfo!]
        }
        
        return updatedInfo
    }
    
    // MARK: - New account
    func setNewAccountData() -> [NewAccountObject] {
        let name = NewAccountObject(with: "Nombre", imageString: "user2")
        let phoneNumber = NewAccountObject(with: "Teléfono", imageString: "phone")
        let email = NewAccountObject(with: "Dirección", imageString: "mail")
        let address = NewAccountObject(with: "Compañía", imageString: "company")
        return [name, phoneNumber, email, address]
    }
}
