//
//  EditInfoViewController.swift
//  savedTech
//
//  Created by Salvador Ramirez on 3/30/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import iOSDropDown

struct Techies {
    var nombre_techie: String
    var id_techie: String
}

class EditInfoViewController: UIViewController {

    var id_Info: String = ""
    var documentId: String = ""
    var idTech: String = ""
    var techies: [Techies] = []
    var tempTech: [String] = []
    
    let db = Firestore.firestore()
    var titleFromBase: String = ""
    var isButtonHidden: Bool = false
    @IBOutlet weak var titleLbl: UILabel!
    
    /*Techies*/
    var isTechie: Bool = false
    
    /*Enterprises*/
    var isClient: Bool = false
    
    /*Report*/
    var isReport: Bool = false
    @IBOutlet weak var textEditDescription: UITextView!
    @IBOutlet weak var enterpriseName: UILabel!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var editReport: UIButton!
    @IBOutlet weak var techInCharge: UILabel!
    @IBOutlet weak var techInChargeDrop: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTechies()
        
        techInChargeDrop.layer.borderWidth = 1.0
        techInChargeDrop.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        textEditDescription.layer.borderColor = #colorLiteral(red: 0.6118932424, green: 0.6118932424, blue: 0.6118932424, alpha: 1)
        textEditDescription.layer.borderWidth = 1.0
        
        titleLbl.text = titleFromBase
        editReport.isHidden = isButtonHidden
        
        if titleFromBase == "Edit Reports" || titleFromBase == "Report Revision" {
            isReport = true
            print("Id_Info : \(id_Info)")
            getInfoFromReport()
        }
        
        if titleFromBase == "Ticket Revision" {
            print("Id_Info : \(id_Info)")
            getInfoFromTickets()
        }
        
        if titleFromBase == "Edit Client Info" {
            isClient = true
        }
        
        if titleFromBase == "Edit Ticket Info" {
            isTechie = true
            getInfoFromTickets()
        }
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            navigationItem.leftBarButtonItem = backButton
    }
    
    func getTechies(){
        techInCharge.isHidden = true
        techInChargeDrop.isHidden = false
        let docRef = db.collection("users")
        docRef.getDocuments(completion: { (documents, error) in
            if error != nil{
                print(error!)
            } else {
                for document in (documents?.documents)!{
                    let userType = document.data()["type_user"] as? String
                    if userType == "tech" {
                        if let username = document.data()["username"] as? String {
                            self.tempTech.append(username)
                            let idUser = document.data()["id_User"]
                            self.techies.append(Techies(nombre_techie: username, id_techie: idUser as! String))
                        }
                    }
                }
                
                // The list of array to display. Can be changed dynamically
                
                self.techInChargeDrop.optionArray = self.tempTech
                //Its Id Values and its optional
                self.techInChargeDrop.optionIds = [1,23,54,22]

                // The the Closure returns Selected Index and String
                self.techInChargeDrop.didSelect{(selectedText , index ,id) in
                    
                    self.idTech = self.techies[index].id_techie
                }
            }
        })
    }
    
    func getInfoFromTickets(){
        techInCharge.isHidden = false
        techInChargeDrop.isHidden = true
        let docRef = self.db.collection("tickets")
        docRef.whereField("id_Ticket", isEqualTo: id_Info).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.documentId = document.documentID
                        self.textEditDescription.text = document.data()["descripcion"] as? String
                        self.techInCharge.text = self.getInfoFromTech(idTechie: document.data()["id_Techie"] as? String ?? "")
                    }
                }
        }
    }
    
    func getInfoFromUser(idUser: String){
        let docRef = self.db.collection("users")
        docRef.whereField("id_User", isEqualTo: idUser).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docs = document.data()["empresa"] as! String
                    self.enterpriseName.text = "\(docs)"
                }
            }
        }
    }
    
    func getInfoFromTech(idTechie: String) -> String{
        var name: String = ""
        
        let docRef = self.db.collection("users")
        
        if idTechie.isEmpty {
            self.techInCharge.isHidden = true
            self.techInChargeDrop.isHidden = false
        }
        
        docRef.whereField("id_User", isEqualTo: idTechie).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docs = document.data()["username"] as! String
                        self.techInCharge.text = docs
                        if docs.isEmpty {
                            self.techInCharge.isHidden = true
                            self.techInChargeDrop.isHidden = false
                            return name = docs
                        } else {
                            self.techInCharge.isHidden = false
                            self.techInChargeDrop.isHidden = true
                        }
                    }
                }
        }
        
        return name
    }
    
    func getInfoFromReport(){
        techInCharge.isHidden = false
        techInChargeDrop.isHidden = true
        let docRef = self.db.collection("reportes")
        docRef.whereField("id_Report", isEqualTo: id_Info).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.documentId = document.documentID
                        self.textEditDescription.text = document.data()["descripcion"] as? String
                        self.techInCharge.text = self.getInfoFromTech(idTechie: document.data()["id_Techie"] as? String ?? "")
                        self.getInfoFromUser(idUser: document.data()["id_Empresa"] as? String ?? "")
                    }
                }
        }
    }
        
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateReport(_ sender: Any) {
        if isReport {
            let reports = db.collection("reportes").document(documentId)
            
            reports.updateData([
                "id_Techie": idTech ,
                "descripcion" : textEditDescription.text ?? ""
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
}
