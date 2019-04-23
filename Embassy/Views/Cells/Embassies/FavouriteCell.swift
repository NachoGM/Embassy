//
//  FavouriteCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var embassyImage: UIImageView!
    @IBOutlet weak var embassyTitle: UILabel!
    @IBOutlet weak var embassyCity: UILabel!
    @IBOutlet weak var embassyAddress: UILabel!

    func setFavouriteEmbassy(embassy:Embassy) {
        guard let title = embassy.name else { return }
        guard let address = embassy.address else { return }
        guard let locality = embassy.locality else { return }
        
        self.embassyTitle.text = title
        self.embassyAddress.text = address
        self.embassyCity.text = locality

        if title.contains("Consulado") {
            self.embassyImage.image = UIImage(named: "council")
        } else {
            self.embassyImage.image = UIImage(named: "embassy")
        }
    }

}
