//
//  SidebarObject.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class SidebarObject {

    var name: String!
    var icon: String!
    var hasDetail: Bool!
    var detailNum: String!
    var detailColor: UIColor!
    
    var isSelected: Bool!
    
    init(with name:String, icon:String, hasDetail:Bool, detailNum:String, detailColor: UIColor) {
        self.name = name
        self.icon = icon
        self.hasDetail = hasDetail
        self.detailNum = detailNum
        self.detailColor = detailColor
    }
    
 
    init(profile isSelected:Bool) {
        self.isSelected = isSelected
    }
    
}
