//
//  ProfileObject.swift
//  Embassy
//
//  Created by Nacho González Miró on 10/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import UIKit

class ProfileObject {
    var title: String!
    var description: String!
    var imageString: String!
    var userImageList: [UIImage]!
    
    init(with title:String, description:String, imageString:String, userImageList:[UIImage]) {
        self.title = title
        self.description = description
        self.imageString = imageString
        self.userImageList = userImageList
    }
}
