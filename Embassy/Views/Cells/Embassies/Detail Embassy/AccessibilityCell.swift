//
//  AccessibilityCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 31/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class AccessibilityCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    func setAccessibilityCell(embassy:Embassy) {
        self.titleLb.text = "Accesibilidad"
        
        setYellowStars(number:Int(truncating:embassy.accessibility!))
    }
    
    func setYellowStars(number:Int) {
        let starChecked = "star-checked"
        let starUnchecked = "star-unchecked"
        if number != 0 {
            setStarRate(number: number, imageName: starChecked)
        } else {
            setStarRate(number: number, imageName: starUnchecked)
        }
    }
    
    func setStarRate(number:Int, imageName:String) {
        var starList : [UIImageView] = [self.star1, self.star2, self.star3, self.star4, self.star5]
        if number > 0 {
            for i in 0...number {
                starList[i].image = UIImage(named: imageName)
            }
        }
    }

}
