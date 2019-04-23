//
//  TitleCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 31/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    func setTitleCell(embassy:Embassy) {
        self.titleLb.text = embassy.name
        
        if let title = embassy.name {
            if title.contains("Consulado") {
                self.detailImage.image = UIImage(named: "council")
            } else if title.contains("Embajada") {
                self.detailImage.image = UIImage(named: "embassy")
            } else {
                self.detailImage.backgroundColor = .red 
            }
        }
    }
    
}
