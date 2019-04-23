//
//  UnderConstructionVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 09/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class UnderConstructionVC: UIViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        displayMenuBtn(button: menuBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showInformativeErrorMessage(message: "Este apartado se encuentra en construcción. /n/n Invita a una cerveza al desarrollador e intenta convencerle.")
    }
}
