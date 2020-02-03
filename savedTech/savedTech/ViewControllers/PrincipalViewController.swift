//
//  PrincipalViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PrincipalViewController: UIViewController {

    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    var typeOfUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        
        let docRef = db.collection("users").document(userID ?? "")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let email = document.data()?["email"] as? String
                self.typeOfUser = document.data()?["type_user"] as? String ?? ""
                let name = document.data()?["username"] as? String
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                self.nombreLbl.text = name
                self.emailLbl.text = email
                self.userTypeLbl.text = self.typeOfUser
                
                if self.typeOfUser != "admin" { self.registerBtn.isHidden = true }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
