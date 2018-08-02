//
//  registryPointModel.swift
//  cadastro
//
//  Created by Aramis Araujo on 02/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase


struct RegistryPoint {
    
    var id: String
    var userId: String
    var userName: String
    var registryPoint: GeoPointType
    
    var dictionary: [String: Any] {
        return [
            "userId": userId,
            "userName": userName,
            "registryPoint": GeoPoint.init(latitude: registryPoint.latitude, longitude: registryPoint.longitude)
        ]
    }
}


extension RegistryPoint {
    
    init?(dictionary: [String: Any], id: String) {
        guard let userId = dictionary["userId"] as? String,
            let userName = dictionary["userName"] as? String,
            let registryPoint = dictionary["registryPoint"] as? GeoPointType
            else {return nil}
        
        self.init(id: id, userId: userId, userName: userName, registryPoint: registryPoint)
    }
}
