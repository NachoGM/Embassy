//
//  Connectivity.swift
//  Embassy
//
//  Created by Nacho González Miró on 24/03/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
