//
//  MapCell.swift
//  Embassy
//
//  Created by Nacho González Miró on 31/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
   
    private var locationManager = CLLocationManager()
    private var location = CLLocation()

    func setMapCell(embassy:Embassy) {
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        setMapView()
        
        if let lat = embassy.lat {
            if let lng = embassy.lng {
                setInitialLocation(lat: Double(truncating: lat), lng: Double(truncating: lng))
                
                let poiLocation = CLLocation(latitude: Double(truncating: lat), longitude: Double(truncating: lng))
                locationManager(locationManager, didUpdateLocations: [poiLocation])
                
                setLocationPoi(location: locationManager)
            }
        }
        
    }
    
    func setMapView() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
    }
    
    func setLocationPoi(location:CLLocationManager) {
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    func setInitialLocation(lat:Double, lng:Double) {
        let initialLocation = CLLocation(latitude: lat, longitude: lng)
        centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

}

extension MapCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "map"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        
        pinView!.image = UIImage(named: "council-poi")
        
        return pinView
        
    }
}

extension MapCell: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            mapView.addAnnotation(annotation)
        }
    }
}
