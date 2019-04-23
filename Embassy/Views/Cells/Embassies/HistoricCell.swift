//
//  HistoricCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 02/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class HistoricCell: UITableViewCell {

    @IBOutlet weak var nameSearchedLb: UILabel!
    @IBOutlet weak var dateSearchedLb: UILabel!
    @IBOutlet weak var latSearchedLb: UILabel!
    @IBOutlet weak var lngSearchedLb: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    func setEmbassyViewed(embassyViewed:Embassy) {
        guard let title = embassyViewed.name else {return}
        guard let date = embassyViewed.dateString else {return}
        guard let lat = embassyViewed.lat else {return}
        guard let lng = embassyViewed.lng else {return}
        
        self.nameSearchedLb.text = title
        self.dateSearchedLb.text = date
        self.latSearchedLb.text = "\(lat)"
        self.lngSearchedLb.text = "\(lng)"

        if title.contains("Consulado") {
            self.searchImage.image = UIImage(named: "council")
        } else {
            self.searchImage.image = UIImage(named: "embassy")
        }
    }
}
