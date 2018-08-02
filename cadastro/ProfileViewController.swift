//
//  ProfileViewController.swift
//  cadastro
//
//  Created by Aramis Araujo on 01/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import Eureka
import ViewRow


class ProfileViewController: FormViewController {
    
    
    var user:User? = nil
    
    func pushBack(){
        
        self.performSegue(withIdentifier: "pushBackListing", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< ViewRow<UIImageView>().cellSetup { (cell, row) in
                
                cell.view = UIImageView()
                cell.contentView.addSubview(cell.view!)
                
                
                let photoRef = Storage.storage().reference(forURL: self.user!.photo)
                
                photoRef.getData(maxSize: 30 * 1024 * 1024){ data, error in
                    if let error = error {
                        print(error)
                    }
                    else{
                        cell.view!.image = UIImage(data: data!)
                    }
                    
                    
                }

                cell.viewRightMargin = 0.0
                cell.viewLeftMargin = 0.0
                cell.viewTopMargin = 0.0
                cell.viewBottomMargin = 0.0
                cell.height = { return CGFloat(300) }
            }
            
        <<< TextRow(){
            $0.title = "Nome: \(user!.name)"
            $0.tag = "userName"
            } <<< TextRow(){
                $0.title = "CPF: \(user!.cpf)"
                $0.tag = "userCPF"
                
        } <<< TextRow(){
            $0.title = "Idade: \(String(user!.age))"
            $0.tag = "userAge"
                    
        } +++ Section()
            <<< ButtonRow(){ row in
                row.title = "Retornar"
                }.onCellSelection{(cell, row) in self.pushBack()}
            
     
            
        form.rowBy(tag: "userName")?.baseCell.isUserInteractionEnabled = false
        form.rowBy(tag: "userCPF")?.baseCell.isUserInteractionEnabled = false
        form.rowBy(tag: "userAge")?.baseCell.isUserInteractionEnabled = false
        
        
        
    }
        
        
                
    
    
    
}



