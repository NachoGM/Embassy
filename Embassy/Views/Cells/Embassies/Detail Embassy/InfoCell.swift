//
//  InfoCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 31/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var detailLb: UILabel!

    func setEmbassyInfo(titleList:[String], detailList:[String], indexPath:IndexPath) {
        self.titleLb.text = titleList[indexPath.row]
        self.detailLb.text = detailList[indexPath.row]
    }

}
