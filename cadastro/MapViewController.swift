//
//  MapViewController.swift
//  cadastro
//
//  Created by Aramis Araujo on 01/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate {
    

    
    @IBOutlet weak var map: MKMapView!
    
    

    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firestore.firestore().collection("registryPoints").getDocuments(){ (snapshot, error) in
            if let error = error{
                print("Failed to fetch registrypoints \(error)")
            }
            else{
                for document in snapshot!.documents{
                    
                    let regPoint = RegistryPoint.init(dictionary: document.data(), id: document.documentID)
                    
                    let annotation: MKPointAnnotation = MKPointAnnotation()
                    annotation.title = regPoint?.userName
                    annotation.coordinate = CLLocationCoordinate2D(latitude: regPoint!.registryPoint.latitude, longitude: regPoint!.registryPoint.longitude)
                    
                    self.map.addAnnotation(annotation)
                    
                }
            }
        }
    }
        
//        for regPoint in self.regPoints{
//
//            let annotation: MKPointAnnotation = MKPointAnnotation()
//            annotation.title = regPoint.userId
//            annotation.coordinate = CLLocationCoordinate2D(latitude: regPoint.registryPoint.latitude, longitude: regPoint.registryPoint.longitude)
//
//            self.annotations.append(annotation)
//        }
//
//        print("Annotations \(self.annotations)")
//        self.map.addAnnotations(self.annotations)
//
//        let testAnottation = MKPointAnnotation()
//        testAnottation.title = "Cristo"
//        testAnottation.coordinate = CLLocationCoordinate2DMake(-22.951739, -43.210461)
//        self.map.addAnnotation(testAnottation)
//    }
//
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//
//    }
//


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

