//
//  PhotosCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 11/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImg: UIImageView!
    
    func setPhotoCell(image:UIImage) {
        self.photoImg.image = image
    }
}
