//
//  ViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginAction: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }

    @IBAction func logInAction(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let password = passField.text ?? ""
        
        let docRef = self.db.collection("users")
        docRef.whereField("email", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count < 1 {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "You no longer have acces. Contact Manager."
                } else {
                    Auth.auth().signIn(withEmail: username, password: password) { (users, error) in
                        if users != nil{
                            // Safe Present
                            self.performSegue(withIdentifier: "login", sender: self)
                        }else{
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "Email or Password Incorrect. Try Again."
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgotView") as? ForgotViewController
        {
            vc.modalPresentationStyle = .popover
            //let navController = UINavigationController(rootViewController: vc)
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

