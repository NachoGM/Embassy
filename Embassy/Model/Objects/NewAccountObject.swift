//
//  NewAccountObject.swift
//  Embassy
//
//  Created by Nacho González Miró on 11/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation

class NewAccountObject {
    var imageString: String!
    var title: String!
    
    init(with title:String, imageString:String) {
        self.imageString = imageString
        self.title = title
    }
}
