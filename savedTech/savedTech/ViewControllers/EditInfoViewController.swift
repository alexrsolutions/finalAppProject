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

class EditInfoViewController: UIViewController {

    var id_Info: String = ""
    var documentId: String = ""
    
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
    @IBOutlet weak var techInCharge: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func getInfoFromTickets(){
        let docRef = self.db.collection("tickets")
        docRef.whereField("id_Ticket", isEqualTo: id_Info).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.documentId = document.documentID
                        self.textEditDescription.text = document.data()["descripcion"] as? String
                        self.techInCharge.text = document.data()["id_Techie"] as? String
                    }
                }
        }
    }
    
    func getInfoFromReport(){
        let docRef = self.db.collection("reportes")
        docRef.whereField("id_Report", isEqualTo: id_Info).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.documentId = document.documentID
                        self.textEditDescription.text = document.data()["descripcion"] as? String
                        self.techInCharge.text = document.data()["id_Techie"] as? String
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
                "id_Techie": techInCharge.text ?? "Not Selected",
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
