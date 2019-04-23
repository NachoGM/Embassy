//
//  SearchDetailVC.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SearchDetailVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var resultNumView: UIView!
    @IBOutlet weak var resultNumLb: UILabel!
    @IBOutlet weak var resultTitleLb: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Global variables
    var lngSearched: Double!
    var latSearched: Double!
    
    var serviceDb = ServiceDataBase()
    var resultSearchedList = [Embassy]()
    var location = CLLocationManager()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchedList = serviceDb.loadEmbassy(isSearched: false)
        initDataLabels()
        initViewStyles()
        setLocationManager()
        setMapView()
        setInitialLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Estás en SearchDetail VC")
    }
    
    func initDataLabels() {
        if !resultSearchedList.isEmpty {            
            self.resultNumLb.text = "\(self.resultSearchedList.count)"
            self.resultTitleLb.text = "Embajadas localizadas"
        }
    }
    
    func initViewStyles() {
        self.resultNumView.layer.cornerRadius = self.resultNumView.frame.height / 2
        self.resultNumView.layer.borderWidth = 1
        self.resultNumView.layer.borderColor = UIColor.red.cgColor
    }
    
    func setLocationManager() {
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    func setMapView() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
    }
    
    func setInitialLocation() {
        let initialLocation = CLLocation(latitude: latSearched, longitude: lngSearched)
        centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "poiDetail" {
            let destinationVC = segue.destination as! PoiDetailedVC
            destinationVC.embassy = sender as? Embassy
            destinationVC.modalTransitionStyle = .crossDissolve
            destinationVC.modalPresentationStyle = .overCurrentContext
        }
    }
    
    // MARK: IBAction
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchDetailVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotations = view.annotation?.coordinate.latitude else { return }

        let locations = self.resultSearchedList
        for location in locations {
            if annotations == CLLocationDegrees(truncating: location.lat!) {
                self.performSegue(withIdentifier: "poiDetail", sender: location)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "map"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        
        let locations = self.resultSearchedList
        for location in locations {
            if location.name!.contains("Consulado") {
                pinView?.image = UIImage(named: "council-poi")
            } else {
                pinView?.image = UIImage(named: "embassy-poi")
            }
        }
        
        return pinView
    }
}

extension SearchDetailVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locations = self.resultSearchedList
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat as! CLLocationDegrees, longitude: location.lng as! CLLocationDegrees)
            mapView.addAnnotation(annotation)
        }
        mapView.reloadInputViews()
    }
}
