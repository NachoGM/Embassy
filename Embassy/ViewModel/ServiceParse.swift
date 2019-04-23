//
//  ServiceParse.swift
//  Embassy
//
//  Created by Nacho González Miró on 26/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServiceParse {

    var serviceDb = ServiceDataBase()

    func parseEmbassy(object:[[String : Any]]) {
        for graph in object {
            let address = graph["address"] as! [String:Any]
            var location = handleLocationObject(object: graph)
            let organization = graph["organization"] as! [String:Any]
            
            let title = graph["title"] as? String
            let street = address["street-address"] as? String
            let postalCode = address["postal-code"] as? String
            let locality = address["locality"] as? String
            let direction = "\(street!), \(postalCode!)"
            let latitude = location["latitude"] as? Double
            let longitude = location["longitude"] as? Double
            let organizationDesc = organization["organization-desc"] as? String
            let accessibility = organization["accessibility"] as? NSNumber
            let accesssibilityNumber = handleAccessibilityObject(number: accessibility)
            let accessibilityInt = Int(truncating: accesssibilityNumber)
            
            serviceDb.saveEmbassy(
                title: title ?? "Título no disponible",
                streetAddress: direction,
                locality: locality ?? "Localidad no disponible",
                lat: latitude ?? 0.0,
                lng: longitude ?? 0.0,
                metro: organizationDesc ?? "Metro info no disponible",
                accessibility: accessibilityInt,
                dateString: "",
                isSearched: false)
        }
    }
    

    func handleLocationObject(object:[String : Any]) -> [String:Any] {
        var location = [String : Any]()
        if object.count < 8 {
            location = ["latitude":40.463370, "longitude":-3.675127]
        } else {
            location = object["location"] as! [String:Any]
        }
        return location
    }
    
    func handleAccessibilityObject(number:NSNumber?) -> NSNumber {
        var currentNumber = NSNumber(integerLiteral: 0)
        if number != nil {
            currentNumber = number!
        }
        return currentNumber
    }
    
}
