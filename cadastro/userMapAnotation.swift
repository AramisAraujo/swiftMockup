//
//  userMapAnotation.swift
//  cadastro
//
//  Created by Aramis Araujo on 02/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import Foundation
import MapKit

class userAnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
