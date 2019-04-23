//
//  AccountCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var userMailLb: UILabel!
    @IBOutlet weak var accountSettingsBtn: UIButton!
    
    func setUserProfileCell(object:User, isAccountBtnSelected:Bool) {
        self.userNameLb.text = object.name
        self.userMailLb.text = object.email
        self.profileImg.image = UIImage(data: object.image! as Data)
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
        self.profileImg.layer.borderColor = UIColor.white.cgColor
        self.profileImg.layer.borderWidth = 2
        
        if !isAccountBtnSelected {
            self.accountSettingsBtn.setImage(UIImage(named: "ic_closed"), for: .normal)
        } else {
            self.accountSettingsBtn.setImage(UIImage(named: "ic_opened"), for: .normal)
        }
        
        
        
        self.accountSettingsBtn.layer.shadowColor = UIColor.black.cgColor
        self.accountSettingsBtn.layer.shadowOpacity = 1
        self.accountSettingsBtn.layer.shadowOffset = CGSize.zero
        self.accountSettingsBtn.layer.shadowRadius = 10
    }
}
