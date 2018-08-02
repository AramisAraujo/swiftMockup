//
//  userModel.swift
//  cadastro
//
//  Created by Aramis Araujo on 01/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

public protocol GeoPointType: FirestoreDecodable, FirestoreEncodable {
    var latitude: Double { get }
    var longitude: Double { get }
    init(latitude: Double, longitude: Double)
}

struct User {
    var name: String
    var age: Int
    var cpf: String
    var photo: String
    var id: String
    var registryGeopoint: GeoPointType
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "age": age,
            "cpf": cpf,
            "photo": photo,
            "registryGeopoint": GeoPoint.init(latitude: registryGeopoint.latitude, longitude: registryGeopoint.longitude)
        ]
    }
}


extension User {
    
    init?(dictionary: [String: Any], id: String) {
        guard let name = dictionary["name"] as? String,
        let age = dictionary["age"] as? Int,
        let cpf = dictionary["cpf"] as? String,
        let photo = dictionary["photo"] as? String,
        let registryGeopoint = dictionary["registryGeopoint"] as? GeoPointType
            else {return nil}
        
        self.init(name: name, age: age, cpf: cpf, photo: photo,
                  id: id, registryGeopoint: registryGeopoint)
    }
}
