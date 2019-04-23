//
//  NewAccountCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 11/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import TextFieldEffects

class NewAccountCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var textField: HoshiTextField!
    
    func setNewAccountCell(object:NewAccountObject) {
        self.iconImg.image = UIImage(named:object.imageString)
        self.textField.placeholder = object.title
    }
}
