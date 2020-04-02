//
//  EditUserViewController.swift
//  savedTech
//
//  Created by Salvador Ramirez on 4/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditUserViewController: UIViewController {

    var headingTitle = ""
    var id_Info = ""
    var documentId: String = ""
    let db = Firestore.firestore()
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var enterpriseInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerTitle.text = headingTitle
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        getInfoFromReport()
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    func getInfoFromReport(){
        let docRef = self.db.collection("users")
        docRef.whereField("id_User", isEqualTo: id_Info).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.documentId = document.documentID
                        self.addressInput.text = document.data()["address"] as? String
                        self.usernameInput.text = document.data()["username"] as? String
                        self.phoneInput.text = document.data()["phone"] as? String
                        self.enterpriseInput.text = document.data()["empresa"] as? String
                    }
                }
        }
    }
    
    @IBAction func updateUser(_ sender: Any) {
        let users = db.collection("users").document(documentId)
        
        users.updateData([
            "address": addressInput.text ?? "Not Selected",
            "username" : usernameInput.text ?? "",
            "phone" : phoneInput.text ?? "",
            "empresa" : enterpriseInput.text ?? ""
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
