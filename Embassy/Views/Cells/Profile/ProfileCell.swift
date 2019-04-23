//
//  ProfileCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 10/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageList = [UIImage]()
    
    func setProfileCell(object:ProfileObject) {
        if object.title != "Photos" {
            self.descriptionLb.isHidden = false
            self.collectionView.isHidden = true
            self.descriptionLb.text = object.description
        } else {
            self.descriptionLb.isHidden = true
            self.collectionView.isHidden = false
            self.collectionView.dataSource = self
            self.collectionView.delegate = self 
            imageList = object.userImageList
            self.collectionView.reloadData()
        }
        self.titleLb.text = object.title
        self.profileImg.image = UIImage(named:object.imageString)
        self.selectionStyle = .none
        self.titleLb.sizeToFit()
        self.layoutIfNeeded()
    }
}

// MARK: - CollectionView
extension ProfileCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotosCell
        let item = imageList[indexPath.row]
        cell.setPhotoCell(image: item)
        return cell
    }
}

extension ProfileCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.collectionView.frame.width / 4) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
