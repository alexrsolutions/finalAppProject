//
//  RegisterUserViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegisterUserViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var emailReg: UITextField!
    @IBOutlet weak var nameReg: UITextField!
    @IBOutlet weak var typeReg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regsiterBtn(_ sender: Any) {
        if let email = emailReg.text {
            
            Auth.auth().createUser(withEmail: email, password: "savedTech", completion: { user, error in
                
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    return
                }
                
                let users = self.db.collection("users")
                
                users.document().setData(["email" : self.emailReg.text ?? "", "password" : "savedTech", "type_user" : self.typeReg.text ?? "", "username" : self.nameReg.text ?? ""])
                
            })
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
