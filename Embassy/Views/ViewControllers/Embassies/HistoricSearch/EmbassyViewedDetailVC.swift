//
//  EmbassyViewedDetailVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 29/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class EmbassyViewedDetailVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var baseAlert: UIView!
    @IBOutlet weak var embassyName: UILabel!
    @IBOutlet weak var dateSearched: UILabel!
    @IBOutlet weak var embassyLat: UILabel!
    @IBOutlet weak var embassyLng: UILabel!
    
    var embassy : Embassy!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setBaseAlert(baseAlert: baseAlert)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en EmbassyViewedDetail VC")
        setBlurBg(blurImage: blurImage)
    }
    
    func loadData() {
        guard let title = embassy.name else { return }
        guard let lat = embassy.lat else { return }
        guard let lng = embassy.lng else { return }
        guard let date = embassy.dateString else { return }
        
        self.embassyName.text = title
        self.embassyLat.text = "\(lat)"
        self.embassyLng.text = "\(lng)"
        self.dateSearched.text = date
    }

    // MARK: IBActions
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func moreInfoTapped(_ sender: UIButton) {
        showInformativeErrorMessage(title: "+ Info", message: "Para más información, debes de invitar al desarrollador a una cerveza")
    }
}
