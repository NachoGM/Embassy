//
//  ServiceApi.swift
//  Embassy
//
//  Created by Nacho González Miró on 26/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let URL_BASE = "https://datos.madrid.es/egob/catalogo/201000-0-embajadas-consulados.json"

class ServiceApi {
    
    var serviceDb = ServiceDataBase()
    var serviceParse = ServiceParse()
    
    // MARK: - Search Embassy
    func searchEmbassy(latString:String, lngString:String, distance:String) {
        if Connectivity.isConnectedToInternet {
            Alamofire.request(URL_BASE + "?latitud=\(latString)&longitud=\(lngString)&distancia=\(distance)", method: .get).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        let graphs = parsedData["@graph"] as! [[String:Any]]
                        self.serviceParse.parseEmbassy(object: graphs)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    NSLog("Error en searchEmbassy: \(error.localizedDescription)")
                }
            }
        }
    }
  
    // MARK: - Server Errors Handling
    static func getServerError(_ error: Error) -> ServerError {
        let code = error._code
        let serverError: ServerError
        
        if code == 403 {
            serverError = .unauthorized
            
        } else if code == 404 {
            serverError = .notFound
            
        } else if code >= 500 {
            serverError = .unavailable
            
        } else if code < 0 {
            // Errors related to the NSURLError codes (i.e. -1009 no connection to internet, -1001 timout)
            serverError = .noConnection
            
        } else {
            serverError = .apiError(error)
        }
        
        return serverError
    }
    
}

// MARK: - Response Handling Enums

enum Result<Value> {
    case success(Value)
    case failure(ServerError)
}

enum ServerError {
    case apiError(Error)
    case unauthorized
    case notFound
    case unavailable
    case noConnection
    
    func message() -> String {
        switch self {
        case .apiError(let error):
            return error.localizedDescription
            
        case .unauthorized:
            return NSLocalizedString("No autorizado", comment: "")
            
        case .notFound:
            return NSLocalizedString("Servicio no encontrado", comment: "")
            
        case .unavailable:
            return NSLocalizedString("Servicio temporalmente no disponible. Por favor, intente de nuevo más tarde", comment: "")
            
        case .noConnection:
            return NSLocalizedString("Se ha producido un error en la conexión. Asegúrese de disponer de conexión a internet e inténtelo de nuevo.", comment: "")
        }
    }
}
