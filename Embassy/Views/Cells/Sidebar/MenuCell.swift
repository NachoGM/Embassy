//
//  MenuCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailNumLb: UILabel!
    @IBOutlet weak var nameTrailingConstraint: NSLayoutConstraint!
    
    func setMenuCell(object:SidebarObject) {
        self.iconImg.image = UIImage(named:object.icon)
        self.iconImg.tintColor = .red 
        self.nameLb.text = object.name
        self.detailView.backgroundColor = object.detailColor
        self.detailNumLb.text = object.detailNum
        self.restorationIdentifier = object.name

        if object.hasDetail {
            self.nameTrailingConstraint.constant = 107
            
        } else {
            self.nameTrailingConstraint.constant = 20
            self.detailView.backgroundColor = .clear
        }
    }

}
