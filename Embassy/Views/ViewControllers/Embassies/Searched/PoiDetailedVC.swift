//
//  PoiDetailedVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 02/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

class PoiDetailedVC: UIViewController {

    @IBOutlet weak var blurImg: UIImageView!
    @IBOutlet weak var baseAlert: UIView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var cityLb: UILabel!
    @IBOutlet weak var latLb: UILabel!
    @IBOutlet weak var lngLb: UILabel!
    @IBOutlet weak var poiImg: UIImageView!
    
    var embassy : Embassy!
    var serviceDb = ServiceDataBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBaseAlert(baseAlert: baseAlert)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estoy en PoiDetailed VC")
        setBlurBg(blurImage: blurImg)
    }
    
    func loadData() {
        guard let title = embassy.name else { return }
        guard let date = embassy.dateString else { return }
        guard let address = embassy.address else { return }
        guard let locality = embassy.locality else { return }
        guard let lat = embassy.lat else { return }
        guard let lng = embassy.lng else { return }
        
        self.titleLb.text = title
        self.dateLb.text = date
        self.addressLb.text = address
        self.cityLb.text = locality
        self.latLb.text = "\(lat)"
        self.lngLb.text = "\(lng)"
        
        if title.contains("Consulado") {
            self.poiImg.image = UIImage(named: "council-poi")
        } else {
            self.poiImg.image = UIImage(named: "embassy-poi")
        }
    }

    // MARK: IBActions
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = embassy.name else { return }
        guard let address = embassy.address else { return }
        guard let locality = embassy.locality else { return }
        guard let lat = embassy.lat else { return }
        guard let lng = embassy.lng else { return }
        guard let metro = embassy.metro else { return }
        guard let accessibility = embassy.lng else { return }

        serviceDb.saveEmbassy(title: title, streetAddress: address, locality: locality, lat: Double(truncating:lat), lng: Double(truncating:lng), metro: metro, accessibility: Int(truncating:accessibility), dateString: dateToString(date: Date()), isSearched: true)
    }
}
