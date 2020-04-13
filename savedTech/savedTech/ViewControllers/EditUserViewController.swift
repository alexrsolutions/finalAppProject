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
    @IBOutlet weak var warningLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLbl.isHidden = true

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
        warningLbl.isHidden = true
        if checkForExceptions() == false {
            users.updateData([
                "address": addressInput.text ?? "Not Selected",
                "username" : usernameInput.text ?? "",
                "phone" : phoneInput.text ?? "",
                "empresa" : enterpriseInput.text ?? ""
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.warningLbl.isHidden = false;
                    self.warningLbl.text = "Updated Succesfully"
                    self.warningLbl.textColor = UIColor.green
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func checkForExceptions() -> Bool {
        var returnValue = false
        
        if ((enterpriseInput.text == "") || (enterpriseInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Enterprise is empty, please complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((phoneInput.text == "") || (phoneInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Phone is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((usernameInput.text == "") || (usernameInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Username is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((addressInput.text == "") || (addressInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Address is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        }
        
        return returnValue
    }
}
