//
//  SearchEmbassyVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class SearchEmbassyVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var latitudeTf: UITextField!
    @IBOutlet weak var longitudeTf: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var baseAlertView: UIView!
    @IBOutlet weak var distanceInMetersLb: UILabel!
    
    @IBOutlet weak var distanceSlider: UISlider!
    // MARK: Global variables
    var embassyViewed = [Embassy]()
    var serviceApi = ServiceApi()
    var serviceDb = ServiceDataBase()
    var distance = 0
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        initAlert()
        setTextFieldDelegates()
        self.hideKeyboardWhenTappedAround()
        
        self.distanceSlider.minimumValue = 0
        self.distanceSlider.maximumValue = 3000.0
        self.distanceSlider.value = 1000.0
        
        setBaseAlert(baseAlert: baseAlertView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en SearchEmbassy VC")
    }
    
    func initAlert() {
        titleLb.text = "Indíca la latitud y la longitud"
        searchBtn.layer.cornerRadius = 15
    }
    
    func setTextFieldDelegates() {
        self.latitudeTf.delegate = self
        self.longitudeTf.delegate = self
    }

    // MARK: IBAction
    @IBAction func searchTapped(_ sender: UIButton) {
        if (latitudeTf.text?.isEmpty)! || (longitudeTf.text?.isEmpty)! {
            showInformativeErrorMessage(title: "Error",
                                        message: "Rellene los campos de LATITUD y LONGITUD con puntos")
        } else {
            if distance == 0 {
                distance = 1000
            }
            serviceApi.searchEmbassy(latString: latitudeTf.text!, lngString: longitudeTf.text!, distance: "\(distance)")
            let embassyViewedList = serviceDb.loadEmbassy(isSearched: false)
            if !embassyViewedList.isEmpty {
                showResultsInMap()
            }
        }
    }
    @IBAction func distanceTapped(_ sender: UISlider) {
        distance = Int(truncating:NSNumber(value: sender.value))
        self.distanceInMetersLb.text = "Ratio de \(Int(truncating:NSNumber(value: sender.value))) metros"
    }
    
    func showResultsInMap() {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
        let latDouble = Double("\(latitudeTf.text!)")
        let lngDouble = Double("\(longitudeTf.text!)")
        destinationVC.latSearched = latDouble
        destinationVC.lngSearched = lngDouble
        self.present(destinationVC, animated: true, completion: nil)
    }

}

extension SearchEmbassyVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

