//
//  ServiceDataBase.swift
//  Embassy
//
//  Created by Nacho González Miró on 26/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class ServiceDataBase {
    
    func saveEmbassy(title:String, streetAddress:String, locality:String, lat:Double, lng:Double, metro:String, accessibility:Int, dateString:String, isSearched:Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let embassyEntity = NSEntityDescription.entity(forEntityName: "Embassy", in: managedContext)
        
        let embassy = Embassy(entity:embassyEntity!, insertInto:managedContext)
        embassy.name = title
        embassy.address = streetAddress
        embassy.locality = locality
        embassy.lat = lat as NSNumber
        embassy.lng = lng as NSNumber
        embassy.metro = metro
        embassy.accessibility = accessibility as NSNumber
        embassy.dateString = dateString
        embassy.isSearched = isSearched as NSNumber
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveUser(image:Data, name:String, phone:String, email:String, password:String, address:String, company:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        
        let user = User(entity: userEntity!, insertInto: managedContext)
        user.name = name
        user.phone = phone
        user.email = email
        user.password = password
        user.address = address
        user.company = company
        user.image = image as NSData
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func loadEmbassy(isSearched:Bool) -> [Embassy] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Embassy")
        
        var embassyList = [Embassy]()
        var searchedList = [Embassy]()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            let result = results as! [Embassy]
            let searchFiltered = result.filter({$0.isSearched == true })
            searchedList = searchFiltered
            
            let allEmbassyList = result.filter({$0.isSearched == false })
            embassyList = allEmbassyList
            
        } catch let error as NSError {
            print("Error: \(error), Descripción: \(error.userInfo)")
        }
        
        if isSearched {
            return searchedList
        } else {
            return embassyList
        }
    }
        
    func loadUserProfile() -> [User] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        var userProfile = [User]()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let result = results as! [User]
            userProfile = result
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return userProfile
    }
    
    func saveInUserDefaults(isLoggedIn:Bool, forKey:String) {
        UserDefaults.standard.set(isLoggedIn, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
}
