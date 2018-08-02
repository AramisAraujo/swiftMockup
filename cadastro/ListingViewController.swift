//
//  ListingViewController.swift
//  cadastro
//
//  Created by Aramis Araujo on 01/08/18.
//  Copyright © 2018 Aramis Araujo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListingViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    private var docs: [DocumentSnapshot] = []
    
    public var users: [User] = []
    
    public var selectedUser: User?
    
    private var listener: ListenerRegistration!
    
    
    fileprivate func baseQuery() -> Query {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        let db = Firestore.firestore()
        db.settings = settings
        return db.collection("users").limit(to: 50)
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.query = baseQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listener.remove()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listener = query?.addSnapshotListener { (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            let results = snapshot.documents.map { (document) -> User in
                if let user = User(dictionary: document.data(), id: document.documentID){
                    return user
                } else{
                    fatalError("Unable to initialize type \(User.self) with dictionary \(document.data())")
                }
            }
            self.users = results
            self.docs = snapshot.documents
            self.tableView.reloadData()
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = users[indexPath.row]
        
        cell.textLabel!.text = item.name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell number: \(indexPath.row)!")
        
        self.selectedUser = users[indexPath.row]
        
        print("doc id \(users[indexPath.row].id)")
        self.performSegue(withIdentifier: "pushProfileView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pushProfileView"){
            let vc = segue.destination as! ProfileViewController
            vc.user = self.selectedUser
        }
    }

    
    
}

