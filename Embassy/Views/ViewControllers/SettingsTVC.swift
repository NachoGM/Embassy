//
//  SettingsTVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayMenuBtn(button: menuBtn)
        themeSelector.selectedSegmentIndex = Theme.current.rawValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en Settings TVC")
    }

    @IBAction func applyTheme(_ sender: UIButton) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            if themeSelector.selectedSegmentIndex == 1 {
                Theme.dark.apply()
            } else {
                selectedTheme.apply()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
