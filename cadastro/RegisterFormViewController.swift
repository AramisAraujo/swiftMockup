//
//  ViewController.swift
//  cadastro
//
//  Created by Aramis Araujo on 31/07/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import UIKit
import ImageRow
import Eureka
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage
import CodableFirebase

extension GeoPoint: GeoPointType {}

class RegisterFormViewController: FormViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var userCurrentLocation:CLLocationCoordinate2D?
    
    @IBAction func showAlertRegister() {
        
        // create the alert
        let alert = UIAlertController(title: "Cadastro", message: "Cadastro Concluído.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertFillForm() {
        
        // create the alert
        let alert = UIAlertController(title: "Campos Vazios", message: "Preencha todos os campos!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        form +++ Section()
            <<< ImageRow() {row in
                row.title = "Foto"
                row.tag = "picRow"
                row.sourceTypes = .PhotoLibrary
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
            }
            //        +++ Section()
            <<< TextRow(){
                $0.title = "Nome"
                $0.tag = "nameRow"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                
            }
            //        +++ Section()
            <<< IntRow(){
                $0.title = "Idade"
                $0.tag = "ageRow"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                
            }
            //        +++ Section()
            <<< TextRow(){
                $0.title = "CPF"
                $0.tag = "cpfRow"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Salvar Cadastro"
                }.onCellSelection{ (cell, row) in self.saveEntry()

            }

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let userLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        self.userCurrentLocation = userLocation
    }
    
    func saveEntry(){
        
        
        if (!form.validate().isEmpty){
            
            self.showAlertFillForm()
            return
        }
        
        let formData = form.values()
        
        let image = formData["picRow"] as? UIImage
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageRef = Storage.storage().reference().child("users").child("\(imageName)")
    
        if let imageData = UIImageJPEGRepresentation(image!, 0.8) {
            
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else{
                print(error)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else{
                    print("Failed to fetch downloadURL")
                    return
                    }
                }
            }
    }
        
        let geoPoint = GeoPoint.init(latitude: (self.userCurrentLocation?.latitude)!, longitude: (self.userCurrentLocation?.longitude)!)
        
        
        let userInfo = [
            "name": formData["nameRow"],
            "age": formData["ageRow"],
            "cpf": formData["cpfRow"],
            "photo": "gs://cadastropessoasmockup.appspot.com/\(imageRef.fullPath)",
            "registryGeopoint": geoPoint
        ]
        
        var docRef: DocumentReference? = nil
        docRef = Firestore.firestore().collection("users").addDocument(data: userInfo){ err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else{
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
        
        var regPointRef: DocumentReference? = nil

        regPointRef = Firestore.firestore().collection("registryPoints").addDocument(data: ["userId": docRef?.documentID, "registryPoint": geoPoint, "userName":  userInfo["name"]]) { err in
            if let err = err{
                print("Error registering geopoint \(err)")
            }
            else{
                print("Geopoint saved sucessfully")
            }
        }
        
        self.showAlertRegister()
        tableView.reloadData()
    }
    
    
}

